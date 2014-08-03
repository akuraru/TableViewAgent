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

struct HasSelectors {
    let didSelectCell: Bool
    let deleteCell: Bool
    let cellIdentifier: Bool
    let sectionTitle: Bool
    let addCellIdentifier: Bool
    let commonViewObject: Bool
    let didSelectAdditionalCell: Bool
    let addSectionTitle: Bool
    let addSectionHeightForHeader: Bool
    let addSectionHeader: Bool
    let sectionHeightForHeader: Bool
    let sectionHeader: Bool
    let cellHeight: Bool
}


class TableViewAgent : NSObject, UITableViewDelegate, UITableViewDataSource {
    var hasSelectors :HasSelectors
    var editableState: EditableState
    var addState: AdditionalCellState
    var _editing = false
    public var editing: Bool {
    get {
        return _editing
    }
    set(b) {
        if (editableState.canEdit() && editing != b) {
            _editing = b;
            _delegate.tableView.setEditing(!(b), animated: false)
            _delegate.tableView.setEditing(b, animated: true)
            setAddCellHide(addState.changeInState(editing))
        }
    }
    }
    var viewObjects: AgentViewObjectProtocol!
    
    var _delegate: TableViewAgentDelegate!
    var delegate: TableViewAgentDelegate! {
    get { return _delegate }
    set(d) {
        hasSelectors = createHasSelectors(d)
        _delegate = d;
        d.tableView.delegate = self
        d.tableView.dataSource = self
    }
    }
    init() {
        hasSelectors = HasSelectors(didSelectCell: false, deleteCell: false, cellIdentifier: false, sectionTitle: false, addCellIdentifier: false, commonViewObject: false, didSelectAdditionalCell: false, addSectionTitle: false, addSectionHeightForHeader: false, addSectionHeader: false, sectionHeightForHeader: false, sectionHeader: false, cellHeight: false)
        editableState = EditableState()
        addState = AdditionalCellState()
    }
    init(vo :AgentViewObjectProtocol, d :TableViewAgentDelegate) {
        hasSelectors = HasSelectors(didSelectCell: false, deleteCell: false, cellIdentifier: false, sectionTitle: false, addCellIdentifier: false, commonViewObject: false, didSelectAdditionalCell: false, addSectionTitle: false, addSectionHeightForHeader: false, addSectionHeader: false, sectionHeightForHeader: false, sectionHeader: false, cellHeight: false)
        editableState = EditableState()
        addState = AdditionalCellState()
        viewObjects = vo
        _delegate = d
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
        _delegate.tableView.reloadData()
    }
    func viewObjectForIndexPath(indexPath :NSIndexPath) -> AnyObject {
        return viewObjects.objectAtIndexPath(indexPath)
    }
    func deleteCell(indexPath :NSIndexPath) {
        if self.compareSectionCount(viewObjects.sectionCount()) != NSComparisonResult.OrderedSame {
            _delegate.tableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation:UITableViewRowAnimation.Automatic)
        } else {
            _delegate.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    func compareSectionCount(sectionCount: Int) -> NSComparisonResult {
        let left = viewObjects.sectionCount()
        let right = _delegate.tableView.numberOfSections() - (addState.isShowAddCell(editing) ? 1 : 0)
        return left < right ? NSComparisonResult.OrderedAscending : left == right ? NSComparisonResult.OrderedSame : NSComparisonResult.OrderedDescending
    }
    func deleteCellsAtSection(section :Int,rows :[Int]) {
        if compareSectionCount(viewObjects.sectionCount()) != NSComparisonResult.OrderedSame {
            _delegate.tableView.deleteSections(NSIndexSet(index: section), withRowAnimation:UITableViewRowAnimation.Automatic)
        } else {
            _delegate.tableView.deleteRowsAtIndexPaths(indexPathsForSection(section, rows: rows), withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    func insertCell(indexPath :NSIndexPath) {
        if compareSectionCount(viewObjects.sectionCount()) != NSComparisonResult.OrderedSame {
            _delegate.tableView.insertSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Automatic)
        } else {
            _delegate.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    func insertCellsAtSection(section :Int, rows: [Int]) {
        if compareSectionCount(viewObjects.sectionCount()) != NSComparisonResult.OrderedSame {
            _delegate.tableView.insertSections(NSIndexSet(index: section), withRowAnimation: UITableViewRowAnimation.Automatic)
        } else {
            _delegate.tableView.insertRowsAtIndexPaths(indexPathsForSection(section, rows: rows), withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    func indexPathsForSection(section :Int, rows:[Int]) ->  [NSIndexPath] {
        return rows.map{NSIndexPath(forRow: $0, inSection: section)}
    }
    func changeUpdateCell(indexPath :NSIndexPath) {
        _delegate.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    func changeMoveCell(indexPath :NSIndexPath, newIndexPath :NSIndexPath) {
        let tableView = _delegate.tableView;
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
    // UITableViewDelegate
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            if (hasSelectors.deleteCell) {
                let viewObject: AnyObject = viewObjectWithIndex(indexPath);
                delegate.deleteCell!(viewObject)
            }
            viewObjects.removeObjectAtIndexPath(indexPath)
        }
    }
    func viewObjectWithIndex(indexPath :NSIndexPath) -> AnyObject {
        return viewObjects.objectAtIndexPath(indexPath)
    }
    // UITableViewDataSouer
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        if isAdditionalSection(section) {
            return 1
        } else {
            return viewObjects.countInSection(section)
        }
    }
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        if isAdditionalSection(indexPath.section) {
            return createAdditionalCell(tableView) as UITableViewCell;
        } else {
            return createCell(indexPath) as UITableViewCell;
        }
    }
    func isAdditionalSection(section :Int) -> Bool {
        return viewObjects.sectionCount() == section
    }
    
    func createAdditionalCell(tableView :UITableView) -> AnyObject {
        return tableView.dequeueReusableCellWithIdentifier(delegate.addCellIdentifier!())
    }
    func createCell(indexPath :NSIndexPath) -> AnyObject {
        let viewObject: AnyObject = viewObjectWithIndex(indexPath)
        let cell: AnyObject = dequeueCell(indexPath)
        if cell as? TableViewAgentCellDelegate {
            cell.setViewObject(viewObject)
        }
        return cell;
    }
    func dequeueCell(indexPath: NSIndexPath) -> AnyObject {
        let viewObject: AnyObject = viewObjectWithIndex(indexPath);
        return _delegate.tableView.dequeueReusableCellWithIdentifier(_delegate.cellIdentifier(viewObject))
    }
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        if isAdditionalSection(indexPath.section) {
            let cell: AnyObject = createAdditionalCell(tableView)
            if cell.respondsToSelector(NSSelectorFromString("heightFromViewObject")) {
                return  cell.heightFromViewObject(viewObjectWithIndex(indexPath));
            } else {
                return cell.frame.size.height
            }
        } else {
            let cell: AnyObject = dequeueCell(indexPath);
            if cell.respondsToSelector(NSSelectorFromString("heightFromViewObject")) {
                return cell.heightFromViewObject(viewObjectWithIndex(indexPath))
            } else {
                return cell.frame.size.height
            }
        }
    }
    func tableView(tableView: UITableView!, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath!) {
        self.tableView(tableView, didSelectRowAtIndexPath: indexPath)
    }
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if isAdditionalSection(indexPath.section) {
            delegate.didSelectAdditionalCell!()
        } else {
            delegate.didSelectCell!(viewObjectWithIndex(indexPath))
        }
    }
    func numberOfSectionsInTableView(tableView :UITableView) -> Int {
        return viewObjects.sectionCount() + (addState.isShowAddCell(editing) ? 1 : 0)
    }
    func tableView(tableView :UITableView, canEditRowAtIndexPath indexPath:NSIndexPath) -> Bool {
        return editableState.canEdit() && isAdditionalSection(indexPath.section) == false;
    }
    func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        if isAdditionalSection(section) {
            if hasSelectors.addSectionTitle {
                return _delegate.addSectionTitle!();
            }
        } else if hasSelectors.sectionTitle {
            return delegate.sectionTitle!(viewObjects.sectionObjects(section));
        }
        return ""
    }
    func tableView(tableView: UITableView!, heightForHeaderInSection section: Int) -> CGFloat {
        if isAdditionalSection(section) {
            if hasSelectors.addSectionHeightForHeader {
                return delegate.addSectionHeightForHeader!()
            } else if hasSelectors.addSectionHeader {
                return delegate.addSectionHeader!().frame.size.height
            }
        } else {
            if (hasSelectors.sectionHeightForHeader) {
                return delegate.sectionHeightForHeader!(viewObjects.sectionObjects(section));
            } else if (hasSelectors.sectionHeader) {
                return delegate.sectionHeader!(viewObjects.sectionObjects(section)).frame.size.height
            }
        }
        return -1;
    }
    
    func tableView(tableView: UITableView!, viewForHeaderInSection section: Int) -> UIView! {
        if isAdditionalSection(section) {
            if (hasSelectors.addSectionHeader) {
                return delegate.addSectionHeader!();
            }
        } else if (hasSelectors.sectionHeader) {
            return delegate.sectionHeader!(viewObjects.sectionObjects(section));
        }
        return nil;
    }
    func insertRowWithSection(section :Int, createSection b :Bool) {
        if (b) {
            _delegate.tableView.insertSections(NSIndexSet(index: section), withRowAnimation: UITableViewRowAnimation.Automatic)
        } else {
            _delegate.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: viewObjects.countInSection(section) - 1, inSection:section)], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    func hideAddCell() {
        delegate.tableView.deleteSections(NSIndexSet(index: viewObjects.sectionCount()), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    func showAddCell() {
        delegate.tableView.insertSections(NSIndexSet(index: viewObjects.sectionCount()), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    func sectionOfAddCell() -> Int {
        return viewObjects.sectionCount()
    }
    func createHasSelectors(d :TableViewAgentDelegate!) -> HasSelectors {
        return HasSelectors(
            didSelectCell: d.respondsToSelector(NSSelectorFromString("didSelectCell:")),
            deleteCell: d.respondsToSelector(NSSelectorFromString("deleteCell:")),
            cellIdentifier: d.respondsToSelector(NSSelectorFromString("cellIdentifier:")),
            sectionTitle: d.respondsToSelector(NSSelectorFromString("sectionTitle:")),
            addCellIdentifier: d.respondsToSelector(NSSelectorFromString("addCellIdentifier")),
            commonViewObject: d.respondsToSelector(NSSelectorFromString("commonViewObject")),
            didSelectAdditionalCell: d.respondsToSelector(NSSelectorFromString("didSelectAdditionalCell")),
            addSectionTitle: d.respondsToSelector(NSSelectorFromString("addSectionTitle")),
            addSectionHeightForHeader: d.respondsToSelector(NSSelectorFromString("addSectionHeightForHeader")),
            addSectionHeader: d.respondsToSelector(NSSelectorFromString("addSectionHeader")),
            sectionHeightForHeader: d.respondsToSelector(NSSelectorFromString("sectionHeightForHeader:")),
            sectionHeader: d.respondsToSelector(NSSelectorFromString("sectionHeader:")),
            cellHeight: d.respondsToSelector(NSSelectorFromString("cellHeight"))
        )
    }
    
    func setSigleSection(array :[AnyObject]) {
        viewObjects = SSAgentViewObject(array: array, agent: self)
    }
    func setMultiSection(array :[[AnyObject]]) {
        viewObjects = MSAgentViewObject(array: array, agent: self)
    }
    func setFetchedResultController(controller :NSFetchedResultsController) {
        viewObjects = FRCAgentViewObject(controller: controller, agent: self)
    }
    func changeObject(object :AnyObject) {
        viewObjects.changeObject(object)
    }
    func addObject(object :AnyObject,inSection section:Int) {
        viewObjects.addObject(object, inSection: section)
    }
}
