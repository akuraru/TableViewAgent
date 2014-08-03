//
//  FRCAgentViewObject.swift
//  TableViewAgent
//
//  Created by akuraru on 2014/07/31.
//  Copyright (c) 2014年 P.I.akura. All rights reserved.
//

import Foundation
import CoreData


class FRCAgentViewObject<T :AnyObject>: AgentViewObject<T>, NSFetchedResultsControllerDelegate {
    let controller :NSFetchedResultsController!
    weak var agent :TableViewAgent!
    
    init(controller :NSFetchedResultsController, agent: TableViewAgent) {
        super.init()
        self.agent = agent
        self.controller = controller
        controller.delegate = self
    }
    override func sectionCount() -> Int {
        if controller.sections.count == 1 && controller.sections[0].numberOfObjects == 0 {
            return 0
        }
        return controller.sections.count;
    }
    override func countInSection(section :Int) -> Int {
        return controller.sections[section].numberOfObjects
    }
    override func objectAtIndexPath(indexPath :NSIndexPath) -> AnyObject {
        return controller.objectAtIndexPath(indexPath)
    }
    override func removeObjectAtIndexPath(indexPath :NSIndexPath) {
    }
    override func existObject(indexPath :NSIndexPath) -> Bool {
        return indexPath.section < sectionCount() && indexPath.row < countInSection(indexPath.section)
    }
    override func sectionObjects(section :Int) -> AnyObject {
        return objectAtIndexPath(NSIndexPath(forRow: 0, inSection: section))
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
    
    override func changeObject(object :AnyObject) { }
    override func addObject(object :AnyObject,inSection section :Int) { }
}
