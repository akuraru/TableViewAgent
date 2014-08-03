//
//  AgentViewObject.swift
//  TableViewAgent
//
//  Created by akuraru on 2014/08/03.
//  Copyright (c) 2014年 P.I.akura. All rights reserved.
//

import Foundation

class AgentViewObject<T> : AgentViewObjectProtocol {
    func sectionCount() -> Int { return 0 }
    func countInSection(section :Int) -> Int { return 0}
    func objectAtIndexPath(indexPath :NSIndexPath) -> AnyObject {
        return NSObject()
    }
    func removeObjectAtIndexPath(indexPath :NSIndexPath) {}
    func existObject(indexPath :NSIndexPath) -> Bool {return false}
    func sectionObjects(section :Int) -> AnyObject {
        return NSObject()
    }
    
    func changeObject(object :AnyObject) {}
    func addObject(object :AnyObject,inSection section :Int) {}
}