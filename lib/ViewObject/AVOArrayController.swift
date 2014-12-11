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


protocol ArrayController: NSCopying, NSObjectProtocol, Equatable {
}
protocol AVOArrayControllerDelegate {
}

class AVOArrayController<T: ArrayController>: Equatable {
    var delegate: AVOArrayControllerDelegate!
    var fetchedObjects: [T]
    let sortTerm: ((T, T) -> Bool)
    let sectionsByName: (T -> NSCopying)?

    var sections: [AVOArraySectionInfo<T>]!
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
        return self.arrayIndexPath[object] as NSIndexPath?
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
        
        self.fetchedObjects = self.fetchedObjects.filter{t in false == objects.reduce(false, combine: { (b, o) -> Bool in
            b ? true : t.isEqual(o)
        })}
        self.sections = self.createSections()
        let indexPaths = objects.map {o in (o, self.indexPathAtObject(o)) }
//        for (object, indexPath) in indexPaths {
//            self.didChangeObject(object, atIndexPath: nil, forChangeType: NSFetchedResultsChangeType.Insert, newIndexPath: indexPath!)
//        }
        
        self.controllerDidChangeContent()
        
    }
    func updateObject(object: T) {
        self.updateObjects([object])
    }
    func updateObjects(objects: [T]) {
        self.controllerWillChangeConect()
        for o in objects.sorted(self.sortTerm) {
            let index = NSArray(array: self.fetchedObjects).indexOfObject(o)
            if index != NSNotFound {
                self.fetchedObjects[index] = o
            }
        }
        self.fetchedObjects = self.fetchedObjects.sorted(self.sortTerm)
        self.sections = self.createSections()
        
//            let indexPath = self.indexPathAtObject(o)
//            if let ip = indexPath {
//                if (index != NSNotFound) {
//                    self.fetchedObjects[index] = o
//                    self.fetchedObjects = self.fetchedObjects.sorted(self.sortTerm)
//                    self.sections = self.createSections()
//                    let newIndexPath: NSIndexPath = self.indexPathAtObject(o)!
//                    
//                    let type = (ip.isEqual(newIndexPath)) ? NSFetchedResultsChangeType.Update : .Move
//                    self.didChangeObject(o, atIndexPath:ip, forChangeType:type, newIndexPath:newIndexPath)
//                }
//            }
        self.controllerDidChangeContent()
    }
    func insertOrUpdateObject(object: T) {
        self.insertOrUpdateObjects([object])
    }
    func insertOrUpdateObjects(objects: [T]) {
        self.controllerWillChangeConect()
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
        
        self.controllerDidChangeContent()
    }
    func createSections() -> [AVOArraySectionInfo<T>] {
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
            let result = Array<AVOArraySectionInfo<T>>()
            self.arrayIndexPath = createArrayIndexPath(result)
            return result
        } else {
            let result = [self.createSectionInfo(nil, objects: self.fetchedObjects)]
            self.arrayIndexPath = createArrayIndexPath(result)
            return result
        }
    }
    func createArrayIndexPath(result: [AVOArraySectionInfo<T>]) -> NSDictionary {
        var dict = NSMutableDictionary()
        var i = 0
        for index in 0..<(result.count) {
            let info = result[index]
            for row in 0..<(info.numberOfObjects) {
                let object = self.fetchedObjects[i]
                let indexPath = NSIndexPath(forRow: (row - 0), inSection: index)
                dict[object] = indexPath
                i++
            }
        }
        return dict
    }
    func createSectionInfo(name: String?, objects: [T]) -> AVOArraySectionInfo<T> {
        return AVOArraySectionInfo.create(name, indexTitle: name, objects: objects);
    }
    func controllerWillChangeConect() {
//        if self.delegate != nil && moveself.delegate.respondsToSelector(NSSelectorFromString("controllerWillChangeContent:")) {
//            self.delegate.controllerWillChangeContent!(self)
//        }
    }
    func controllerDidChangeContent() {
//        if self.delegate != nil && self.delegate.respondsToSelector(NSSelectorFromString("controllerDidChangeContent:")) {
//            self.delegate.controllerDidChangeContent!(self as AnyObject)
//        }
    }
    func didChangeObject(object: T, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath) {
//        if self.delegate != nil && self.delegate.respondsToSelector(NSSelectorFromString("controller:didChangeObject:atIndexPath:forChangeType:newIndexPath:")) {
//            self.delegate.controller!(self as Any as NSFetchedResultsController, didChangeObject: object, atIndexPath: indexPath, forChangeType: type, newIndexPath: newIndexPath)
//        }
    }
}

func ==<T: ArrayController>(lhs: AVOArrayController<T>, rhs: AVOArrayController<T>) -> Bool {
    let fo1 = lhs.fetchedObjects
    let fo2 = rhs.fetchedObjects
    for (t1, t2) in Zip2(fo1, fo2) {
        if (!(t1.isEqual(t2))) {
            return false
        }
    }
    return lhs.sections == rhs.sections
}

struct AVOArraySectionInfo<T: ArrayController>: Equatable {
    let name: String?
    let indexTitle: String?
    let objects: [T]
    let numberOfObjects: Int
    static func create(name: String?, indexTitle: String?, objects: [T]) -> AVOArraySectionInfo<T> {
        return AVOArraySectionInfo(name: name, indexTitle: indexTitle, objects: objects, numberOfObjects: objects.count)
    }
}

func ==<T: Equatable>(lhs: AVOArraySectionInfo<T>, rhs: AVOArraySectionInfo<T>) -> Bool {
    return lhs.name == rhs.name && lhs.indexTitle == rhs.indexTitle && lhs.objects == rhs.objects
}