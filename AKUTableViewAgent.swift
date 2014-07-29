//
//  AKUTableViewAgent.swift
//  AKUTableViewAgent
//
//  Created by akuraru on 2014/07/16.
//  Copyright (c) 2014年 akuraru. All rights reserved.
//

import Foundation
import UIKit


protocol AgentDelegate {
    var tableView: UITableView { get }
    func deleteCell(AnyObject)
    func addCellIdentifier() -> String
    func cellIdentifier(AnyObject) -> String
    func didSelectAdditionalCell()
    func didSelectCell(AnyObject)
    func sectionTitle(AnyObject) -> String
    func addSectionTitle() -> String
    func addSectionHeightForHeader() -> CGFloat
    func addSectionHeader() -> UIView
    func sectionHeightForHeader(AnyObject) -> CGFloat
    func sectionHeader(AnyObject) -> UIView
}
@objc protocol AgentViewObjectProtocol {
    var agent: AKUTableViewAgent { get set }
    func object(indexPath: NSIndexPath) -> AnyObject
    func sectionCount() -> Int
    func countInSection(Int) -> Int
    func removeObjectAtIndexPath(NSIndexPath)
    func sectionObjects(Int) -> AnyObject
}
@objc protocol AgentTableViewAgentCellDelegate {
    func viewObject(o :AnyObject)
    func heightFromViewObject(o :AnyObject) -> CGFloat
}
class EditableState {
    func editable() -> Bool {
        return false
    }
    func canEdit() -> Bool {
        return false
    }
}
class EditableStateNone: EditableState {
}
class EditableStateEnadle: EditableState {
}

class AdditionalCellState {
    func changeInState(b: Bool) -> Bool {
        return b
    }
    func isShowAddCell(b: Bool) -> Int {
        return 1
    }
}

class AdditionalCellStateNone: AdditionalCellState {
}
class AdditionalCellStateAlways: AdditionalCellState {
}
class AdditionalCellStateHideEditing: AdditionalCellState {
}
class AdditionalCellStateShowEditing: AdditionalCellState {
}

class AKUTableViewAgent : NSObject, UITableViewDelegate, UITableViewDataSource {
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
    enum EditableMode {
        case None, Enable
        func state() -> EditableState {
            switch (self) {
            case .None : return EditableStateNone()
            case .Enable : return EditableStateEnadle()
            }
        }
    }
    enum AdditionalCellMode {
        case None, Always, HideEditing, ShowEditing
        func state() -> AdditionalCellState {
            switch (self){
            case .None: return AdditionalCellStateNone()
            case .Always : return AdditionalCellStateAlways()
            case .HideEditing: return AdditionalCellStateHideEditing()
            case .ShowEditing: return AdditionalCellStateShowEditing()
            }
        }
    }
    var hasSelectors: HasSelectors
    var editableState: EditableState
    var addState: AdditionalCellState
    var _editing = false
    public var editing: Bool {
    get {
        return _editing
    }
    set(b) {
        if (editableState.editable() && editing != b) {
            _editing = b;
            _delegate.tableView.setEditing(!(b), animated: false)
            _delegate.tableView.setEditing(b, animated: true)
            setAddCellHide(addState.changeInState(editing))
        }
    }
    }
    var _viewObjects: AgentViewObjectProtocol;
    var viewObjects: AgentViewObjectProtocol {
    get { return _viewObjects }
    set(v) {
        _viewObjects = v
        _viewObjects.agent = self
    }
    }
    
    var _delegate: AgentDelegate
    var deleagte: AgentDelegate {
    get { return _delegate }
    set(d) {
            _delegate = d;
            d.tableView.delegate = self
            d.tableView.dataSource = self
    }
    }
    init(vo :AgentViewObjectProtocol, d :AgentDelegate) {
        hasSelectors = HasSelectors(didSelectCell: false, deleteCell: false, cellIdentifier: false, sectionTitle: false, addCellIdentifier: false, commonViewObject: false, didSelectAdditionalCell: false, addSectionTitle: false, addSectionHeightForHeader: false, addSectionHeader: false, sectionHeightForHeader: false, sectionHeader: false, cellHeight: false)
        editableState = EditableState()
        addState = AdditionalCellState()
        _viewObjects = vo
        _delegate = d
    }
    func setAddCellHide(b: Bool) {
    }
    func reload() {
        self.editing = false
        _delegate.tableView.reloadData()
    }
    func setAdditionalCellMode(mode: AdditionalCellMode) {
        addState = mode.state()
    }
    func setEditableMode(mode: EditableMode) {
        editableState = mode.state()
    }
    func viewObjectForIndexPath(indexPath :NSIndexPath) -> AnyObject {
        return _viewObjects.object(indexPath);
    }
    func deleteCell(indexPath :NSIndexPath) {
        if self.compareSectionCount(_viewObjects.sectionCount()) != NSComparisonResult.OrderedSame {
            _delegate.tableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation:UITableViewRowAnimation.Automatic)
        } else {
            _delegate.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    func compareSectionCount(sectionCount: Int) -> NSComparisonResult {
        let left = viewObjects.sectionCount()
        let right = _delegate.tableView.numberOfSections() - addState .isShowAddCell(editing)
        return left < right ? NSComparisonResult.OrderedAscending : left == right ? NSComparisonResult.OrderedSame : NSComparisonResult.OrderedDescending
    }
    func deleteCellsAtSection(section :Int,rows :[Int]) {
        if compareSectionCount(_viewObjects.sectionCount()) != NSComparisonResult.OrderedSame {
            _delegate.tableView.deleteSections(NSIndexSet(index: section), withRowAnimation:UITableViewRowAnimation.Automatic)
        } else {
            _delegate.tableView.deleteRowsAtIndexPaths(indexPathsForSection(section, rows: rows), withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    func insertCell(indexPath :NSIndexPath) {
        if compareSectionCount(_viewObjects.sectionCount()) != NSComparisonResult.OrderedSame {
            _delegate.tableView.insertSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Automatic)
        } else {
            _delegate.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    func insertCellsAtSection(section :Int, rows: [Int]) {
        if compareSectionCount(_viewObjects.sectionCount()) != NSComparisonResult.OrderedSame {
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
        switch compareSectionCount(_viewObjects.sectionCount()) {
        case .OrderedSame:
            if _viewObjects.countInSection(newIndexPath.section) == 1 {
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
                _delegate.deleteCell(viewObject)
            }
            _viewObjects.removeObjectAtIndexPath(indexPath)
        }
    }
    func viewObjectWithIndex(NSIndexPath) -> AnyObject {
        return 0
    }
    // UITableViewDataSouer
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        if isAdditionalSection(section) {
            return 1
        } else {
            return _viewObjects.countInSection(section)
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
        return _viewObjects.sectionCount() == section
    }
    
    func createAdditionalCell(tableView :UITableView) -> AnyObject {
        return tableView.dequeueReusableCellWithIdentifier(_delegate.addCellIdentifier())
    }
    func createCell(indexPath :NSIndexPath) -> AnyObject {
        let viewObject: AnyObject = viewObjectWithIndex(indexPath)
        let cell: AnyObject = dequeueCell(indexPath)
        cell.viewObject(viewObject)
        return cell;
    }
    func dequeueCell(indexPath: NSIndexPath) -> AnyObject {
        let viewObject: AnyObject = viewObjectWithIndex(indexPath);
        return _delegate.tableView.dequeueReusableCellWithIdentifier(_delegate.cellIdentifier(viewObject))
    }
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        if isAdditionalSection(indexPath.section) {
            let cell: AnyObject = createAdditionalCell(tableView)
            return  cell.heightFromViewObject(viewObjectWithIndex(indexPath));
        } else {
            let cell: AnyObject = dequeueCell(indexPath);
            return cell.heightFromViewObject(viewObjectWithIndex(indexPath))
        }
    }
    func tableView(tableView: UITableView!, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath!) {
        self.tableView(tableView, didSelectRowAtIndexPath: indexPath)
    }
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if isAdditionalSection(indexPath.section) {
            _delegate.didSelectAdditionalCell()
        } else {
            _delegate.didSelectCell(viewObjectWithIndex(indexPath))
        }
    }
    func numberOfSectionsInTableView(tableView :UITableView) -> Int {
        return _viewObjects.sectionCount() + addState.isShowAddCell(editing);
    }
    func tableView(tableView :UITableView, canEditRowAtIndexPath indexPath:NSIndexPath) -> Bool {
        return editableState.canEdit() && isAdditionalSection(indexPath.section) == false;
    }
    func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        if isAdditionalSection(section) {
            if hasSelectors.addSectionTitle {
                return _delegate.addSectionTitle();
            }
        } else if hasSelectors.sectionTitle {
            return _delegate.sectionTitle(_viewObjects.sectionObjects(section));
        }
        return ""
    }
    func tableView(tableView: UITableView!, heightForHeaderInSection section: Int) -> CGFloat {
        if isAdditionalSection(section) {
            if hasSelectors.addSectionHeightForHeader {
                return _delegate.addSectionHeightForHeader()
            } else if hasSelectors.addSectionHeader {
                return _delegate.addSectionHeader().frame.size.height
            }
        } else {
            if (hasSelectors.sectionHeightForHeader) {
                return _delegate.sectionHeightForHeader(_viewObjects.sectionObjects(section));
            } else if (hasSelectors.sectionHeader) {
                return _delegate.sectionHeader(_viewObjects.sectionObjects(section)).frame.size.height
            }
        }
        return -1;
    }
    func tableView(tableView: UITableView!, viewForHeaderInSection section: Int) -> UIView! {
        if isAdditionalSection(section) {
            if (hasSelectors.addSectionHeader) {
                return _delegate.addSectionHeader();
            }
        } else if (hasSelectors.sectionHeader) {
            return _delegate.sectionHeader(_viewObjects.sectionObjects(section));
        }
        return nil;
    }
    func insertRowWithSection(section :Int, createSection b :Bool) {
        if (b) {
            _delegate.tableView.insertSections(NSIndexSet(index: section), withRowAnimation: UITableViewRowAnimation.Automatic)
        } else {
            _delegate.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: _viewObjects.countInSection(section) - 1, inSection:section)], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func createHasSelector(d :Any) -> HasSelectors {
        var s = HasSelectors(didSelectCell: false, deleteCell: false, cellIdentifier: false, sectionTitle: false, addCellIdentifier: false, commonViewObject: false, didSelectAdditionalCell: false, addSectionTitle: false, addSectionHeightForHeader: false, addSectionHeader: false, sectionHeightForHeader: false, sectionHeader: false, cellHeight: false)
        //        s.cellHeight = d.respondsToSelector(@selector(cellHeight:));
        //    s.didSelectCell = [d respondsToSelector:@selector(didSelectCell:)];
        //    s.deleteCell = [d respondsToSelector:@selector(deleteCell:)];
        //    s.cellIdentifier = [d respondsToSelector:@selector(cellIdentifier:)];
        //    s.commonViewObject = [d respondsToSelector:@selector(commonViewObject:)];
        //    s.sectionTitle = [d respondsToSelector:@selector(sectionTitle:)];
        //    s.addCellIdentifier = [d respondsToSelector:@selector(addCellIdentifier)];
        //    s.didSelectAdditionalCell = [d respondsToSelector:@selector(didSelectAdditionalCell)];
        //    s.addSectionTitle = [d respondsToSelector:@selector(addSectionTitle)];
        //    s.addSectionHeightForHeader = [d respondsToSelector:@selector(addSectionHeightForHeader)];
        //    s.addSectionHeader = [d respondsToSelector:@selector(addSectionHeader)];
        //    s.sectionHeightForHeader = [d respondsToSelector:@selector(sectionHeightForHeader:)];
        //    s.sectionHeader = [d respondsToSelector:@selector(sectionHeader:)];
        return s;
    }
    func hideAddCell() {
        _delegate.tableView.deleteSections(NSIndexSet(index: viewObjects.sectionCount()), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    func showAddCell() {
        _delegate.tableView.insertSections(NSIndexSet(index: viewObjects.sectionCount()), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    func sectionOfAddCell() -> Int {
        return viewObjects.sectionCount()
    }
}
