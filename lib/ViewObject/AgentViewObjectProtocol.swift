//
//  AgentViewObjectProtocol.swift
//  TableViewAgent
//
//  Created by akuraru on 2014/07/31.
//  Copyright (c) 2014年 P.I.akura. All rights reserved.
//

import Foundation

protocol AgentViewObjectProtocol {
    func sectionCount() -> Int
    func countInSection(section :Int) -> Int
    func objectAtIndexPath(indexPath :NSIndexPath) -> AnyObject
    func removeObjectAtIndexPath(indexPath :NSIndexPath)
    func existObject(indexPath :NSIndexPath) -> Bool
    func sectionObjects(section :Int) -> AnyObject
    
    func changeObject(object :AnyObject)
    func addObject(object :AnyObject,inSection section :Int)
}