//
//  AVOArrayController.swift
//  TableViewAgent
//
//  Created by akuraru on 2014/11/02.
//  Copyright (c) 2014 P.I.akura. All rights reserved.
//

import Foundation
import UIKit

class AVOArrayController<T: NSCopying> {
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
}