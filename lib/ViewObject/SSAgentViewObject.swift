//
//  SSAgentViewObject.swift
//  TableViewAgent
//
//  Created by akuraru on 2014/07/29.
//  Copyright (c) 2014年 P.I.akura. All rights reserved.
//

import Foundation
import UIKit

class SSAgentViewObject : NSObject, AgentViewObjectProtocol {
    weak var agent :TableViewAgent!
    var array: [AnyObject]
    init(array :[AnyObject], agent: TableViewAgent) {
        self.agent = agent
        self.array = array
    }
    func indexPathForObject(object :AnyObject) -> NSIndexPath? {
         let _len  = array.count
        for var i = 0; i < _len; i++ {
            if object.isEqual(array[0]) {
                return NSIndexPath(forRow: i, inSection: 0)
            }
        }
        return nil
    }
    func addObject(object :AnyObject) {
        array.append(object)
        agent.insertCell(NSIndexPath(forRow: array.count - 1, inSection: 0))
    }
    func changeObject(object :AnyObject) {
        let path = self.indexPathForObject(object)
        if path {
            agent.changeUpdateCell(path!)
        }
    }
    // deleagte
    func sectionCount() -> Int {
        return array.isEmpty ? 0 : 1
    }
    func countInSection(section :Int) -> Int {
        return array.count
    }
    func objectAtIndexPath(indexPath :NSIndexPath) -> AnyObject {
        return array[indexPath.row] as AnyObject
    }
    func removeObjectAtIndexPath(indexPath :NSIndexPath) {
        array.removeAtIndex(indexPath.row)
        agent.deleteCell(indexPath)
    }
    func existObject(indexPath :NSIndexPath) -> Bool {
        let row = indexPath.row
        return 0 <= row && row < array.count
    }
    func sectionObjects(section :Int) -> AnyObject {
        return array.bridgeToObjectiveC() as AnyObject
    }
}