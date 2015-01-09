//
//  AVOArrayController.swift
//  TableViewAgent
//
//  Created by akuraru on 2014/11/02.
//  Copyright (c) 2014 P.I.akura. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol FRCLikeObjectDelegate {
    func controller(didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?)
    func controllerWillChangeContent()
    func controllerDidChangeContent()
}

class FRCLikeObject<T: NSObject>: Equatable {
    var delegate: FRCLikeObjectDelegate!
    var fetchedObjects: [T]
    let sortTerm: ((T, T) -> Bool)
    let sectionsByName: (T -> NSCopying)?

    var sections: [FRCLikeObjectSectionInfo<T>]!
    var arrayIndexPath: NSDictionary!
    
    init(array :[T], groupedBy groupedTerm: (T -> NSCopying)!, sortedBy sortTerm: ((T, T) -> Bool)?) {
        self.sectionsByName = groupedTerm
        
        self.sortTerm = sortTerm != nil ? sortTerm! : {t,u in false}
        self.fetchedObjects = array.sorted(self.sortTerm)
        self.sections = createSections()
    }

    func objectAtIndexPath(indexPath: NSIndexPath) -> T {
        return self.sections[indexPath.section].objects[indexPath.row] as T
    }
    func indexPathAtObject(object: T) -> NSIndexPath? {
        return self.arrayIndexPath[object as AnyObject as NSCopying] as NSIndexPath?
    }
    func addObject(object: T) {
        self.addObjects([object])
    }
    func addObjects(objects: [T]) {
        self.controllerWillChangeConect()
        
        let sortedObjects = objects.sorted(sortTerm)
        self.fetchedObjects = (self.fetchedObjects + sortedObjects).sorted(sortTerm)
        self.sections = self.createSections()
        let indexPaths = sortedObjects.map {o in (o, self.indexPathAtObject(o)) }
        for (object, indexPath) in indexPaths {
            self.didChangeObject(object, atIndexPath: nil, forChangeType: NSFetchedResultsChangeType.Insert, newIndexPath: indexPath!)
        }
        
        self.controllerDidChangeContent()
    }
    func removeObject(object: T) {
        self.removeObjects([object])
    }
    func removeObjects(objects: [T]) {
        self.controllerWillChangeConect()
        
        let indexPaths = objects.map {o in (o, self.indexPathAtObject(o)) }
        self.fetchedObjects = self.fetchedObjects.filter{t in false == objects.reduce(false, combine: { (b, o) -> Bool in
            b ? true : t.isEqual(o)
        })}
        self.sections = self.createSections()
        for (object, indexPath) in indexPaths {
            if let i = indexPath {
                self.didChangeObject(object, atIndexPath: i, forChangeType: NSFetchedResultsChangeType.Delete, newIndexPath: nil)
            }
        }
        
        self.controllerDidChangeContent()
        
    }
    func updateObject(object: T) {
        self.updateObjects([object])
    }
    func updateObjects(objects: [T]) {
        self.controllerWillChangeConect()

        let indexPaths = objects.map{o in self.indexPathAtObject(o)}
        for o in objects.sorted(self.sortTerm) {
            let index = NSArray(array: self.fetchedObjects).indexOfObject(o)
            if index != NSNotFound {
                self.fetchedObjects[index] = o
            }
        }
        self.fetchedObjects = self.fetchedObjects.sorted(self.sortTerm)
        self.sections = self.createSections()

        let newIndexPaths = objects.map{o in self.indexPathAtObject(o)}
        for (o, (oi, ni)) in Zip2(objects, Zip2(indexPaths, newIndexPaths)) {
            if oi != nil {
                let type = (oi!.isEqual(ni)) ? NSFetchedResultsChangeType.Update : .Move
                self.didChangeObject(o, atIndexPath: oi, forChangeType: type, newIndexPath: ni)
            }
        }

        self.controllerDidChangeContent()
    }
    func insertOrUpdateObject(object: T) {
        self.insertOrUpdateObjects([object])
    }
    func insertOrUpdateObjects(objects: [T]) {
        self.controllerWillChangeConect()
        let indexPaths = objects.map{o in self.indexPathAtObject(o)}
        for o in objects.sorted(self.sortTerm) {
            let index = NSArray(array: self.fetchedObjects).indexOfObject(o)
            if index != NSNotFound {
                self.fetchedObjects[index] = o
            } else {
                self.fetchedObjects += [o]
            }
        }
        self.fetchedObjects = self.fetchedObjects.sorted(self.sortTerm)
        self.sections = self.createSections()
        
        let newIndexPaths = objects.map{o in self.indexPathAtObject(o)}
        for (o, (oi, ni)) in Zip2(objects, Zip2(indexPaths, newIndexPaths)) {
            if oi != nil {
                let type = (oi!.isEqual(ni)) ? NSFetchedResultsChangeType.Update : .Move
                self.didChangeObject(o, atIndexPath: oi, forChangeType: type, newIndexPath: ni)
            } else {
                let type = NSFetchedResultsChangeType.Insert
                self.didChangeObject(o, atIndexPath: nil, forChangeType: type, newIndexPath: ni)
            }
        }
        
        self.controllerDidChangeContent()
    }
    func createSections() -> [FRCLikeObjectSectionInfo<T>] {
        if let keyPath = self.sectionsByName {
            let dictionary = NSMutableDictionary()
            for o in self.fetchedObjects {
                let value = keyPath(o)
                if var array = dictionary[value] as? Array<T> {
                    array.append(o)
                    dictionary[value] = array
                } else {
                    dictionary[value] = [o]
                }
            }
            let result = Array<FRCLikeObjectSectionInfo<T>>()
            self.arrayIndexPath = createArrayIndexPath(result)
            return result
        } else {
            let result = [self.createSectionInfo(nil, objects: self.fetchedObjects)]
            self.arrayIndexPath = createArrayIndexPath(result)
            return result
        }
    }
    func createArrayIndexPath(result: [FRCLikeObjectSectionInfo<T>]) -> NSDictionary {
        var dict = NSMutableDictionary()
        var i = 0
        for index in 0..<(result.count) {
            let info = result[index]
            for row in 0..<(info.numberOfObjects) {
                let object = self.fetchedObjects[i]
                let indexPath = NSIndexPath(forRow: (row - 0), inSection: index)
                dict[object as AnyObject as NSCopying] = indexPath
                i++
            }
        }
        return dict
    }
    func createSectionInfo(name: String?, objects: [T]) -> FRCLikeObjectSectionInfo<T> {
        return FRCLikeObjectSectionInfo.create(name, indexTitle: name, objects: objects);
    }
    func controllerWillChangeConect() {
        if let d = self.delegate {
            d.controllerWillChangeContent()
        }
    }
    func controllerDidChangeContent() {
        if let d = self.delegate {
            d.controllerDidChangeContent()
        }
    }
    func didChangeObject(object: T, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        if let d = self.delegate {
            d.controller(didChangeObject: object, atIndexPath: indexPath, forChangeType: type, newIndexPath: newIndexPath)
        }
    }
}

func ==<T: NSObject>(lhs: FRCLikeObject<T>, rhs: FRCLikeObject<T>) -> Bool {
    let fo1 = lhs.fetchedObjects
    let fo2 = rhs.fetchedObjects
    for (t1, t2) in Zip2(fo1, fo2) {
        if (!(t1.isEqual(t2))) {
            return false
        }
    }
    return lhs.sections == rhs.sections
}

struct FRCLikeObjectSectionInfo<T: NSObject>: Equatable {
    let name: String?
    let indexTitle: String?
    let objects: [T]
    let numberOfObjects: Int
    static func create(name: String?, indexTitle: String?, objects: [T]) -> FRCLikeObjectSectionInfo<T> {
        return FRCLikeObjectSectionInfo(name: name, indexTitle: indexTitle, objects: objects, numberOfObjects: objects.count)
    }
}

func ==<T: NSObject>(lhs: FRCLikeObjectSectionInfo<T>, rhs: FRCLikeObjectSectionInfo<T>) -> Bool {
    return lhs.name == rhs.name && lhs.indexTitle == rhs.indexTitle && lhs.objects == rhs.objects
}