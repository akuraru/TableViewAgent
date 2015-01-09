//
//  FRVLikeViewController.swift
//  TableViewAgent
//
//  Created by akuraru on 2015/01/09.
//  Copyright (c) 2015年 P.I.akura. All rights reserved.
//

import UIKit

class FRVLikeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var agent: TableViewAgent<NSString, NSString>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.agent = TableViewAgent<NSString, NSString>()
        
        let likeObject = FRCLikeObject<NSString>(array: ["hgoe"], groupedBy: nil, sortedBy: nil)
        let viewObject = AVOLikeObject(controller: likeObject, agent: self.agent, {s in s})
        self.agent.viewObjects = viewObject
        self.agent.tableView = self.tableView
        self.agent.cellIdentifier = {_ in "Cell"}
    }
}

