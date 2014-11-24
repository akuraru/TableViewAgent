//
//  AgentViewObject.swift
//  TableViewAgent
//
//  Created by akuraru on 2014/08/03.
//  Copyright (c) 2014 P.I.akura. All rights reserved.
//

import Foundation

class AgentViewObject<T : NSObject, U: NSObject> {
    var transform: T -> U
    init(transform: T -> U) {
        self.transform = transform
    }
    
    func sectionCount() -> Int { return 0 }
    func countInSection(section :Int) -> Int { return 0}
    func objectAtIndexPath(indexPath :NSIndexPath) -> U {
        return U()
    }
    func removeObjectAtIndexPath(indexPath :NSIndexPath) {}
    func existObject(indexPath :NSIndexPath) -> Bool {return false}
    func sectionObjects(section :Int) -> U {
        return U()
    }
    
    func changeObject(object :T) {}
    func addObject(object :T,inSection section :Int) {}
}