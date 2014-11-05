//
//  TableViewAgentAdaptor.swift
//  TableViewAgent
//
//  Created by akuraru on 2014/08/04.
//  Copyright (c) 2014 P.I.akura. All rights reserved.
//

import Foundation
import CoreData

class TableViewAgentAdaptor : NSObject {
    let agent: TableViewAgent<NSObject, NSObject>
    var _delegate: TableViewAgentDelegate!
    
    override init() {
        agent = TableViewAgent()
    }
    func setSigleSection(array :[NSObject]) {
        let t = (_delegate != nil) ? {(t: NSObject) in self._delegate.transform!(t) as NSObject} : {u in u}
        agent.viewObjects = SSAgentViewObject(array: array, agent: agent, t)
    }
    func setMultiSection(array :[[NSObject]]) {
        let t = (_delegate != nil) ? {(t: NSObject) in self._delegate.transform!(t) as NSObject} : {u in u}
        agent.viewObjects = MSAgentViewObject(array: array, agent: agent, t)
    }
    func setFetchedResultController(controller :NSFetchedResultsController) {
        let t = (_delegate != nil) ? {(t: NSObject) in self._delegate.transform!(t) as NSObject} : {u in u}
        agent.viewObjects = FRCAgentViewObject(controller: controller, agent: agent, t)
    }
    func changeObject(object :NSObject) {
        agent.viewObjects.changeObject(object)
    }
    func addObject(object :NSObject,inSection section:Int) {
        agent.viewObjects.addObject(object, inSection: section)
    }
    func setDelegate(d :TableViewAgentDelegate!){
        _delegate = d
        
        agent.tableView = d.tableView
        agent.didSelectCell = d.respondsToSelector(NSSelectorFromString("didSelectCell:")) ? {o in
            d.didSelectCell!(o)
            } : nil
        agent.deleteCell = d.respondsToSelector(NSSelectorFromString("deleteCell:")) ? {o in
            d.deleteCell!(o)
            } : nil
        agent.cellIdentifier = d.respondsToSelector(NSSelectorFromString("cellIdentifier:")) ? {o in
            return d.cellIdentifier(o)
            } : nil
        agent.sectionTitle = d.respondsToSelector(NSSelectorFromString("sectionTitle:")) ? {o in
            return d.sectionTitle!(o)
            } : nil
        agent.addCellIdentifier = d.respondsToSelector(NSSelectorFromString("addCellIdentifier")) ? {() in
            return d.addCellIdentifier!()
            } : nil
        agent.didSelectAdditionalCell = d.respondsToSelector(NSSelectorFromString("didSelectAdditionalCell")) ? {() in
            d.didSelectAdditionalCell!()
            } : nil
        agent.addSectionTitle = d.respondsToSelector(NSSelectorFromString("addSectionTitle:")) ? {() in
            return d.addSectionTitle!()
            } : nil
        agent.addSectionHeightForHeader = d.respondsToSelector(NSSelectorFromString("addSectionHeightForHeader")) ? {() in
            return d.addSectionHeightForHeader!()
            } : nil
        agent.addSectionHeader = d.respondsToSelector(NSSelectorFromString("addSectionHeader")) ? {() in
            return d.addSectionHeader!()
            } : nil
        agent.sectionHeightForHeader = d.respondsToSelector(NSSelectorFromString("sectionHeightForHeader:")) ? {o in
            return d.sectionHeightForHeader!(o)
            } : nil
        agent.sectionHeader = d.respondsToSelector(NSSelectorFromString("sectionHeader:")) ? {o in
            return d.sectionHeader!(o)
            } : nil
        agent.cellHeight = d.respondsToSelector(NSSelectorFromString("cellHeight:")) ? {o in
            return d.cellHeight!(o)
            } : nil
        if let vo = agent.viewObjects {
            if d.respondsToSelector(NSSelectorFromString("transform:")) {
                vo.transform = {(t: NSObject) -> NSObject in d.transform!(t) as NSObject}
            }
        }
    }
    func setEditableModel(mode :EditableMode) {
        agent.editableState = createEditableState(mode)
    }
    func createEditableState(mode :EditableMode) -> EditableState {
        switch mode {
        case .Enable: return EditableState.Enable
        case .None: return EditableState.None
        }
    }
    func setAddMode(mode :AdditionalCellMode) {
        agent.addState = createAddState(mode)
    }
    func createAddState(mode :AdditionalCellMode) -> AdditionalCellState {
        switch mode {
        case .None: return .None
        case .HideEditing: return .HideEditing
        case .ShowEditing: return .ShowEditing
        case .Always: return .Always
        }
    }
    func editing() -> Bool {
        return agent.editing
    }
    func setEditing(b :Bool) {
        agent.editing = b
    }
    func reload() {
        agent.reload()
    }
}