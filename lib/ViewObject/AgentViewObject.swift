//
//  AgentViewObject.swift
//  TableViewAgent
//
//  Created by akuraru on 2014/08/03.
//  Copyright (c) 2014年 P.I.akura. All rights reserved.
//

import Foundation

class AgentViewObject<T : NSObject> {
    func sectionCount() -> Int { return 0 }
    func countInSection(section :Int) -> Int { return 0}
    func objectAtIndexPath(indexPath :NSIndexPath) -> T {
        return T()
    }
    func removeObjectAtIndexPath(indexPath :NSIndexPath) {}
    func existObject(indexPath :NSIndexPath) -> Bool {return false}
    func sectionObjects(section :Int) -> T {
        return T()
    }
    
    func changeObject(object :T) {}
    func addObject(object :T,inSection section :Int) {}
}