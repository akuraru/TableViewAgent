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

protocol AVOArrayControllerDelegate: NSObjectProtocol, NSFetchedResultsControllerDelegate {
}

class AVOArrayController<T: NSCopying> {
    var delegate: AVOArrayControllerDelegate!
    var fetchedObjects: [T]
    let sortTerm: ((T, T) -> Bool)
    let sectionsByName: (T -> NSCopying)?

    var sections: [AKUArrayFetchedResultsSectionInfo]!
    var arrayIndexPath: NSDictionary!
    
    init(array :[T], groupedBy groupedTerm: (T -> NSCopying), sortedBy sortTerm: (T, T) -> Bool) {
        self.sectionsByName = groupedTerm
        
        self.sortTerm = sortTerm
        self.fetchedObjects = array.sorted(sortTerm)
        self.sections = createSections()
    }

    func objectAtIndexPath(indexPath: NSIndexPath) -> T {
        return self.sections[indexPath.section].objects[indexPath.row] as T
    }
    func indexPathAtObject(object: T) -> NSIndexPath? {
        let keys: NSArray = self.arrayIndexPath.allKeys
        let index = keys.indexOfObject(object)
        if index != NSNotFound {
            return self.arrayIndexPath[keys[index] as NSCopying] as NSIndexPath?
        } else {
            return nil
        }
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
    func createSections() -> [AKUArrayFetchedResultsSectionInfo] {
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
            let result = Array<AKUArrayFetchedResultsSectionInfo>()
            return result
        } else {
            let result = [self.createSectionInfo(nil, objects: self.fetchedObjects)]
            self.arrayIndexPath = createArrayIndexPath(result)
            return result
        }
    }
    func createArrayIndexPath(result: [AKUArrayFetchedResultsSectionInfo]) -> NSDictionary {
        var dict = NSMutableDictionary()
        for index in 0..<(result.count) {
            let info = result[index]
            for row in 0..<(info.numberOfObjects) {
                let object = self.fetchedObjects[index]
                let indexPath = NSIndexPath(forRow: (row - 0), inSection: index)
                dict[object] = indexPath
            }
        }
        return dict
    }
    func createSectionInfo(name: String?, objects: [T]) -> AKUArrayFetchedResultsSectionInfo {
        var info = AKUArrayFetchedResultsSectionInfo()
        info.name = name;
        info.indexTitle = name;
        info.objects = objects;
        return info;
    }
    func controllerWillChangeConect() {
        if self.delegate != nil && self.delegate.respondsToSelector(NSSelectorFromString("controllerWillChangeContent:")) {
            self.delegate.controllerWillChangeContent!(self as Any as NSFetchedResultsController)
        }
    }
    func controllerDidChangeContent() {
        if self.delegate != nil && self.delegate.respondsToSelector(NSSelectorFromString("controllerDidChangeContent:")) {
            self.delegate.controllerDidChangeContent!(self as Any as NSFetchedResultsController)
        }
    }
    func didChangeObject(object: T, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath) {
        if self.delegate != nil && self.delegate.respondsToSelector(NSSelectorFromString("controller:didChangeObject:atIndexPath:forChangeType:newIndexPath:")) {
            self.delegate.controller!(self as Any as NSFetchedResultsController, didChangeObject: object, atIndexPath: indexPath, forChangeType: type, newIndexPath: newIndexPath)
        }
    }
}