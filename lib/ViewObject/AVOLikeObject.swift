//
//  AVOLikeObject.swift
//  TableViewAgent
//
//  Created by akuraru on 2014/12/13.
//  Copyright (c) 2014年 P.I.akura. All rights reserved.
//

import Foundation
import CoreData


class AVOLikeObjectSupport: NSObject, FRCLikeObjectDelegate {
    weak var agent :TableViewAgent<NSObject, NSObject>!
    init(agent :TableViewAgent<NSObject, NSObject>) {
        self.agent = agent
    }
    func controller(didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch(type) {
        case .Insert:
            agent.insertCell(newIndexPath!)
        case .Delete:
            agent.deleteCell(indexPath!)
        case .Update:
            agent.changeUpdateCell(indexPath!)
        case .Move:
            agent.changeMoveCell(indexPath!, newIndexPath: newIndexPath!)
        }
    }
    func controllerWillChangeContent() {
    }
    func controllerDidChangeContent() {
    }
}

class AVOLikeObject<T: NSObject, U: NSObject>: AgentViewObject<T, U> {
        let controller :FRCLikeObject<T>!
        weak var agent :TableViewAgent<T, U>!
        let support: AVOLikeObjectSupport!
        
        init(controller :FRCLikeObject<T>, agent: TableViewAgent<T, U>, transform: T -> U = ({t in t} as T -> U)) {
            super.init(transform)
            self.agent = agent
            self.controller = controller
            self.support = AVOLikeObjectSupport(agent: a())
            controller.delegate = self.support
        }
        func a() -> TableViewAgent<NSObject, NSObject> {
            return agent as Any as TableViewAgent<NSObject, NSObject>
        }
        override func sectionCount() -> Int {
            if let s = controller.sections {
                if s.count == 1 && s[0].numberOfObjects == 0 {
                    return 0
                }
                return s.count
            } else {
                return 0
            }
        }
        override func countInSection(section :Int) -> Int {
            if let s = controller.sections {
                return s[section].numberOfObjects
            } else {
                return 0;
            }
        }
        override func objectAtIndexPath(indexPath :NSIndexPath) -> U {
            return transform(controller.objectAtIndexPath(indexPath) as T)
        }
        override func removeObjectAtIndexPath(indexPath :NSIndexPath) {
        }
        override func existObject(indexPath :NSIndexPath) -> Bool {
            return indexPath.section < sectionCount() && indexPath.row < countInSection(indexPath.section)
        }
        override func sectionObjects(section :Int) -> U {
            return transform(objectAtIndexPath(NSIndexPath(forRow: 0, inSection: section)) as T)
        }
        
        override func changeObject(object :T) { }
        override func addObject(object :T,inSection section :Int) { }
}
