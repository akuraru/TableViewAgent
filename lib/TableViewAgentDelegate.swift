//
//  TableViewAgentDelegate.swift
//  TableViewAgent
//
//  Created by akuraru on 2014/07/31.
//  Copyright (c) 2014年 P.I.akura. All rights reserved.
//

import Foundation
import UIKit

@objc protocol TableViewAgentDelegate :NSObjectProtocol {
    optional func didSelectCell(viewObject :AnyObject)
    optional func deleteCell(viewObject :AnyObject)
    func cellIdentifier(viewObject :AnyObject) -> String
    optional func commonViewObject(viewObject :AnyObject) -> AnyObject
    var tableView :UITableView { get }
    optional func sectionTitle(viewObjects :AnyObject) -> String
    optional func addCellIdentifier() -> String
    optional func didSelectAdditionalCell()
    optional func addSectionTitle() -> String
    optional func addSectionHeightForHeader() -> CGFloat
    optional func addSectionHeader() -> UIView
    optional func sectionHeightForHeader(viewObject :AnyObject) -> CGFloat
    optional func sectionHeader(viewObject :AnyObject) -> UIView
    optional func cellHeight(viewObject :AnyObject)-> CGFloat
}
