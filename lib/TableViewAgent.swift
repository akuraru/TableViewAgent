//
//  AKUTableViewAgent.swift
//  AKUTableViewAgent
//
//  Created by akuraru on 2014/07/16.
//  Copyright (c) 2014年 akuraru. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TableViewAgentSupport: NSObject, UITableViewDelegate, UITableViewDataSource {
    var agent: TableViewAgent<NSObject>!
    // UITableViewDelegate
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            if let f = agent.deleteCell {
                let viewObject: AnyObject = agent.viewObjectWithIndex(indexPath);
                f(viewObject)
            }
            agent.viewObjects.removeObjectAtIndexPath(indexPath)
        }
    }
    // UITableViewDataSoucer
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if agent.isAdditionalSection(section) {
            return 1
        } else {
            return agent.viewObjects.countInSection(section)
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if agent.isAdditionalSection(indexPath.section) {
            return agent.createAdditionalCell(tableView) as UITableViewCell;
        } else {
            return agent.createCell(indexPath) as UITableViewCell;
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if agent.isAdditionalSection(indexPath.section) {
            let cell: AnyObject = agent.createAdditionalCell(tableView)
            if cell.respondsToSelector(NSSelectorFromString("heightFromViewObject")) {
                let c = cell as TableViewAgentCellDelegate
                return c.heightFromViewObject(agent.viewObjectWithIndex(indexPath));
            } else {
                return cell.frame.size.height
            }
        } else {
            let cell: AnyObject = agent.dequeueCell(indexPath);
            if cell.respondsToSelector(NSSelectorFromString("heightFromViewObject")) {
                return cell.heightFromViewObject(agent.viewObjectWithIndex(indexPath))
            } else {
                return cell.frame.size.height
            }
        }
    }
    func tableView(tableView: UITableView!, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath!) {
        self.tableView(tableView, didSelectRowAtIndexPath: indexPath)
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if agent.isAdditionalSection(indexPath.section) {
            agent.didSelectAdditionalCell!()
        } else {
            agent.didSelectCell!(agent.viewObjectWithIndex(indexPath))
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return agent.viewObjects.sectionCount() + (agent.addState.isShowAddCell(agent.editing) ? 1 : 0)
    }
    func tableView(tableView :UITableView, canEditRowAtIndexPath indexPath:NSIndexPath) -> Bool {
        return agent.editableState.canEdit() && agent.isAdditionalSection(indexPath.section) == false;
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if agent.isAdditionalSection(section) {
            if let t = agent.addSectionTitle {
                return t()
            }
        } else if let t = agent.sectionTitle {
            return t(agent.viewObjects.sectionObjects(section));
        }
        return ""
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if agent.isAdditionalSection(section) {
            if let f = agent.addSectionHeightForHeader {
                return f()
            } else if let f = agent.addSectionHeader {
                return f().frame.size.height
            }
        } else {
            if let f = agent.sectionHeightForHeader {
                return f(agent.viewObjects.sectionObjects(section));
            } else if let f = agent.sectionHeader {
                return f(agent.viewObjects.sectionObjects(section)).frame.size.height
            }
        }
        return -1;
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if agent.isAdditionalSection(section) {
            if let f = agent.addSectionHeader {
                return f();
            }
        } else if let f = agent.sectionHeader {
            return f(agent.viewObjects.sectionObjects(section));
        }
        return nil;
    }
}

class TableViewAgent<T: NSObject> {
    var didSelectCell: (AnyObject -> ())?
    var deleteCell: (AnyObject -> ())?
    var cellIdentifier: (AnyObject -> String)!
    var commonViewObject:(AnyObject -> AnyObject)?
    var _tableView: UITableView!
    var tableView: UITableView! {
        get { return _tableView }
        set(t) {
            _tableView = t
            t.delegate = self.support
            t.dataSource = self.support
        }
    }
    var sectionTitle: (AnyObject -> String)?
    var addCellIdentifier: (() -> String)?
    var didSelectAdditionalCell: (() -> ())?
    var addSectionTitle: (() -> String)?
    var addSectionHeightForHeader: (() -> CGFloat)?
    var addSectionHeader: (() -> UIView)?
    var sectionHeightForHeader: (AnyObject -> CGFloat)?
    var sectionHeader: (AnyObject -> UIView)?
    var cellHeight: (AnyObject-> CGFloat)?
    
    let support: TableViewAgentSupport
    var editableState: EditableState
    var addState: AdditionalCellState
    var _editing = false
    internal var editing: Bool {
    get {
        return _editing
    }
    set(b) {
        if (editableState.canEdit() && editing != b) {
            _editing = b;
            tableView.setEditing(!(b), animated: false)
            tableView.setEditing(b, animated: true)
            setAddCellHide(addState.changeInState(editing))
        }
    }
    }
    var viewObjects: AgentViewObject<T>!
    
    init() {
        self.support = TableViewAgentSupport()
        editableState = EditableState()
        addState = AdditionalCellState()
        self.support.agent = self as Any as TableViewAgent<NSObject>
    }
    init(vo :AgentViewObject<T>, view :UITableView) {
        self.support = TableViewAgentSupport()
        editableState = EditableState()
        addState = AdditionalCellState()
        viewObjects = vo
        tableView = view
        self.support.agent = self as Any as TableViewAgent<NSObject>
    }
    func setAddCellHide(b: Int) {
        switch(b) {
        case 1:
            hideAddCell()
        case 2:
            showAddCell()
        default:
            break
        }
    }
    func reload() {
        self.editing = false
        tableView.reloadData()
    }
    func viewObjectForIndexPath(indexPath :NSIndexPath) -> T {
        return viewObjects.objectAtIndexPath(indexPath)
    }
    func deleteCell(indexPath :NSIndexPath) {
        if self.compareSectionCount(viewObjects.sectionCount()) != NSComparisonResult.OrderedSame {
            tableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation:UITableViewRowAnimation.Automatic)
        } else {
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    func compareSectionCount(sectionCount: Int) -> NSComparisonResult {
        let left = viewObjects.sectionCount()
        let right = tableView.numberOfSections() - (addState.isShowAddCell(editing) ? 1 : 0)
        return left < right ? NSComparisonResult.OrderedAscending : left == right ? NSComparisonResult.OrderedSame : NSComparisonResult.OrderedDescending
    }
    func deleteCellsAtSection(section :Int,rows :[Int]) {
        if compareSectionCount(viewObjects.sectionCount()) != NSComparisonResult.OrderedSame {
            tableView.deleteSections(NSIndexSet(index: section), withRowAnimation:UITableViewRowAnimation.Automatic)
        } else {
            tableView.deleteRowsAtIndexPaths(indexPathsForSection(section, rows: rows), withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    func insertCell(indexPath :NSIndexPath) {
        if compareSectionCount(viewObjects.sectionCount()) != NSComparisonResult.OrderedSame {
            tableView.insertSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Automatic)
        } else {
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    func insertCellsAtSection(section :Int, rows: [Int]) {
        if compareSectionCount(viewObjects.sectionCount()) != NSComparisonResult.OrderedSame {
            tableView.insertSections(NSIndexSet(index: section), withRowAnimation: UITableViewRowAnimation.Automatic)
        } else {
            tableView.insertRowsAtIndexPaths(indexPathsForSection(section, rows: rows), withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    func indexPathsForSection(section :Int, rows:[Int]) ->  [NSIndexPath] {
        return rows.map{NSIndexPath(forRow: $0, inSection: section)}
    }
    func changeUpdateCell(indexPath :NSIndexPath) {
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    func changeMoveCell(indexPath :NSIndexPath, newIndexPath :NSIndexPath) {
        tableView.beginUpdates();
        switch compareSectionCount(viewObjects.sectionCount()) {
        case .OrderedSame:
            if viewObjects.countInSection(newIndexPath.section) == 1 {
                tableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Automatic)
                tableView.insertSections(NSIndexSet(index: newIndexPath.section), withRowAnimation: UITableViewRowAnimation.Automatic)
            } else {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        case .OrderedAscending:
            tableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Automatic)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        case .OrderedDescending:
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            tableView.insertSections(NSIndexSet(index: newIndexPath.section), withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        tableView.endUpdates()
    }
    func viewObjectWithIndex(indexPath :NSIndexPath) -> T {
        return viewObjects.objectAtIndexPath(indexPath)
    }
    func isAdditionalSection(section :Int) -> Bool {
        return viewObjects.sectionCount() == section
    }
    
    func createAdditionalCell(tableView :UITableView) -> AnyObject {
        return tableView.dequeueReusableCellWithIdentifier(addCellIdentifier!())!
    }
    func createCell(indexPath :NSIndexPath) -> AnyObject {
        let viewObject = viewObjectWithIndex(indexPath)
        let cell: AnyObject = dequeueCell(indexPath)
        if let c = cell as? TableViewAgentCellDelegate {
            c.setViewObject(viewObject)
        }
        return cell;
    }
    func dequeueCell(indexPath: NSIndexPath) -> AnyObject {
        let viewObject: AnyObject = viewObjectWithIndex(indexPath);
        return tableView.dequeueReusableCellWithIdentifier(cellIdentifier(viewObject))!
    }
    func insertRowWithSection(section :Int, createSection b :Bool) {
        if (b) {
            tableView.insertSections(NSIndexSet(index: section), withRowAnimation: UITableViewRowAnimation.Automatic)
        } else {
            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: viewObjects.countInSection(section) - 1, inSection:section)], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    func hideAddCell() {
        tableView.deleteSections(NSIndexSet(index: viewObjects.sectionCount()), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    func showAddCell() {
        tableView.insertSections(NSIndexSet(index: viewObjects.sectionCount()), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    func sectionOfAddCell() -> Int {
        return viewObjects.sectionCount()
    }
}
