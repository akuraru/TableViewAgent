//
//  SSAgentViewObject.swift
//  TableViewAgent
//
//  Created by akuraru on 2014/07/29.
//  Copyright (c) 2014年 P.I.akura. All rights reserved.
//

import Foundation
import UIKit

class SSAgentViewObject<T: NSObject, U: NSObject> : AgentViewObject<T, U> {
    weak var agent :TableViewAgent<T, U>!
    var array: [T]
    
    init(array :[T], agent: TableViewAgent<T, U>, transform: T -> U = ({t in t} as T -> U)) {
        self.agent = agent
        self.array = array
        super.init(transform)
    }
    func indexPathForObject(object :T) -> NSIndexPath? {
         let _len  = array.count
        for var i = 0; i < _len; i++ {
            if object.isEqual(array[0]) {
                return NSIndexPath(forRow: i, inSection: 0)
            }
        }
        return nil
    }
    override func addObject(object :T,inSection section :Int) {
        array.append(object)
        agent.insertCell(NSIndexPath(forRow: array.count - 1, inSection: 0))
    }
    override func changeObject(object :T) {
        let path = self.indexPathForObject(object)
        if path != nil {
            agent.changeUpdateCell(path!)
        }
    }
    // deleagte
    override func sectionCount() -> Int {
        return array.isEmpty ? 0 : 1
    }
    override func countInSection(section :Int) -> Int {
        return array.count
    }
    override func objectAtIndexPath(indexPath :NSIndexPath) -> U {
        return transform(array[indexPath.row])
    }
    override func removeObjectAtIndexPath(indexPath :NSIndexPath) {
        array.removeAtIndex(indexPath.row)
        agent.deleteCell(indexPath)
    }
    override func existObject(indexPath :NSIndexPath) -> Bool {
        let row = indexPath.row
        return 0 <= row && row < array.count
    }
    override func sectionObjects(section :Int) -> U {
        return transform(array[section])
    }
}