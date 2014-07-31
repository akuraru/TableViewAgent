//
//  MSAgentViewObject.swift
//  TableViewAgent
//
//  Created by akuraru on 2014/07/30.
//  Copyright (c) 2014年 P.I.akura. All rights reserved.
//

import Foundation

class MSAgentViewObject : NSObject, AgentViewObjectProtocol {
    strong var agent :TableViewAgent
    var array : [[AnyObject]]
    init(array :[[AnyObject]], agent: TableViewAgent) {
        self.agent = agent
        self.array = array
    }
    func addObject(object :AnyObject,inSection section :Int) {
        if array.count <= section {
            array.append(Array<AnyObject>())
        }
        array[section].append(object)
        agent.insertCell(NSIndexPath(forRow: array[section].count - 1, inSection: section))
    }
    func changeObject(object :AnyObject) {
        agent.changeUpdateCell(indexPathForObject(object))
    }
    func indexPathForObject(object :AnyObject) -> NSIndexPath! {
        for var i = 0, _len = array.count; i < _len; i++ {
            for var j = 0, _len = array[i].count; j < _len; j++ {
                if array[i][j].isEqual(object) {
                    return NSIndexPath(forRow: j, inSection: i)
                }
            }
        }
        return nil;
    }
    func sectionCount() -> Int {
        return array.count
    }
    func countInSection(section :Int) -> Int {
        return array[section].count
    }
    func objectAtIndexPath(indexPath :NSIndexPath) -> AnyObject{
        return array[indexPath.section][indexPath.row]
    }
    func removeObjectAtIndexPath(indexPath :NSIndexPath) {
        var a = array[indexPath.section];
        a.removeAtIndex(indexPath.row)
        array[indexPath.section] = a
        if a.count == 0 {
            array.removeAtIndex(indexPath.section)
        }
        agent.deleteCell(indexPath)
    }
    func existObject(indexPath :NSIndexPath) -> Bool {
        return indexPath.section < array.count && indexPath.row < array[indexPath.section].count;
    }
    func sectionObjects(section :Int) -> AnyObject {
        return array[section]
    }
}