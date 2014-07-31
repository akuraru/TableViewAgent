//
//  TableViewAgentCellDelegate.swift
//  TableViewAgent
//
//  Created by akuraru on 2014/07/31.
//  Copyright (c) 2014年 P.I.akura. All rights reserved.
//

import Foundation
import UIKit

@objc protocol TableViewAgentCellDelegate : NSObjectProtocol {
    func setViewObject(o :AnyObject)
    optional func setViewObject(o :AnyObject, common :AnyObject)
    func heightFromViewObject(o :AnyObject) -> CGFloat
}