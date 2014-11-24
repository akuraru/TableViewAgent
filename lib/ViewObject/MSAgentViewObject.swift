//
//  MSAgentViewObject.swift
//  TableViewAgent
//
//  Created by akuraru on 2014/07/30.
//  Copyright (c) 2014 P.I.akura. All rights reserved.
//

import Foundation

class MSAgentViewObject<T : NSObject, U: NSObject> : AgentViewObject<T, U> {
    weak var agent :TableViewAgent<T, U>!
    var array : [[T]]
    
    init(array :[[T]], agent: TableViewAgent<T, U>, transform: T -> U = ({t in t} as T->U)) {
        self.agent = agent
        self.array = array
        super.init(transform)
    }
    override func addObject(object :T,inSection section :Int) {
        if array.count <= section {
            array.append(Array<T>())
        }
        array[section].append(object)
        agent.insertCell(NSIndexPath(forRow: array[section].count - 1, inSection: section))
    }
    override func changeObject(object :T) {
        agent.changeUpdateCell(indexPathForObject(object))
    }
    func indexPathForObject(object :T) -> NSIndexPath! {
        for var i = 0, _len = array.count; i < _len; i++ {
            for var j = 0, _len = array[i].count; j < _len; j++ {
                if array[i][j].isEqual(object) {
                    return NSIndexPath(forRow: j, inSection: i)
                }
            }
        }
        return nil;
    }
    override func sectionCount() -> Int {
        return array.count
    }
    override func countInSection(section :Int) -> Int {
        return array[section].count
    }
    override func objectAtIndexPath(indexPath :NSIndexPath) -> U {
        return transform(array[indexPath.section][indexPath.row])
    }
    override func removeObjectAtIndexPath(indexPath :NSIndexPath) {
        var a = array[indexPath.section];
        a.removeAtIndex(indexPath.row)
        array[indexPath.section] = a
        if a.count == 0 {
            array.removeAtIndex(indexPath.section)
        }
        agent.deleteCell(indexPath)
    }
    override func existObject(indexPath :NSIndexPath) -> Bool {
        return indexPath.section < array.count && indexPath.row < array[indexPath.section].count;
    }
    override func sectionObjects(section :Int) -> U {
        return transform(array[section][0])
    }
}