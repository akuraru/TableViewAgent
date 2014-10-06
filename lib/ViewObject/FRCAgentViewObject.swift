//
//  FRCAgentViewObject.swift
//  TableViewAgent
//
//  Created by akuraru on 2014/07/31.
//  Copyright (c) 2014年 P.I.akura. All rights reserved.
//

import Foundation
import CoreData

class Support :NSObject, NSFetchedResultsControllerDelegate {
    weak var agent :TableViewAgent!
    init(agent :TableViewAgent!) {
        self.agent = agent
    }
    func controller(controller: NSFetchedResultsController!, didChangeObject anObject: AnyObject!, atIndexPath indexPath: NSIndexPath!, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath!) {
        switch(type) {
        case NSFetchedResultsChangeType.Insert:
            agent.insertCell(newIndexPath)
        case NSFetchedResultsChangeType.Delete:
            agent.deleteCell(indexPath)
        case NSFetchedResultsChangeType.Update:
            agent.changeUpdateCell(indexPath)
        case NSFetchedResultsChangeType.Move:
            agent.changeMoveCell(indexPath, newIndexPath: newIndexPath)
        }
    }
}

class FRCAgentViewObject<T :NSObject>: AgentViewObject<T> {
    let controller :NSFetchedResultsController!
    weak var agent :TableViewAgent!
    let support:Support!
    
    init(controller :NSFetchedResultsController, agent: TableViewAgent) {
        super.init()
        self.agent = agent
        self.controller = controller
        self.support = Support(agent: agent)
        controller.delegate = self.support
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
    override func objectAtIndexPath(indexPath :NSIndexPath) -> T {
        return controller.objectAtIndexPath(indexPath) as T
    }
    override func removeObjectAtIndexPath(indexPath :NSIndexPath) {
    }
    override func existObject(indexPath :NSIndexPath) -> Bool {
        return indexPath.section < sectionCount() && indexPath.row < countInSection(indexPath.section)
    }
    override func sectionObjects(section :Int) -> AnyObject {
        return objectAtIndexPath(NSIndexPath(forRow: 0, inSection: section))
    }
    
    override func changeObject(object :T) { }
    override func addObject(object :T,inSection section :Int) { }
}
