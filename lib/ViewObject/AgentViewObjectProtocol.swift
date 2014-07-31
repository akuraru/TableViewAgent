//
//  AgentViewObjectProtocol.swift
//  TableViewAgent
//
//  Created by akuraru on 2014/07/31.
//  Copyright (c) 2014年 P.I.akura. All rights reserved.
//

import Foundation

@objc protocol AgentViewObjectProtocol {
    weak var agent :TableViewAgent! { get set }
    func sectionCount() -> Int
    func countInSection(section :Int) -> Int
    func objectAtIndexPath(indexPath :NSIndexPath) -> AnyObject
    func removeObjectAtIndexPath(indexPath :NSIndexPath)
    func existObject(indexPath :NSIndexPath) -> Bool
    func sectionObjects(section :Int) -> AnyObject
}