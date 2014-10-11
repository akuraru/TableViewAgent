//
//  TableViewAgentAdaptor.swift
//  TableViewAgent
//
//  Created by akuraru on 2014/08/04.
//  Copyright (c) 2014年 P.I.akura. All rights reserved.
//

import Foundation
import CoreData

class TableViewAgentAdaptor : NSObject {
    let agent: TableViewAgent<NSObject>
    var _detegate: TableViewAgentDelegate!
    
    override init() {
        agent = TableViewAgent()
    }
    func setSigleSection(array :[NSObject]) {
        agent.viewObjects = SSAgentViewObject(array: array, agent: agent)
    }
    func setMultiSection(array :[[NSObject]]) {
        agent.viewObjects = MSAgentViewObject(array: array, agent: agent)
    }
    func setFetchedResultController(controller :NSFetchedResultsController) {
        agent.viewObjects = FRCAgentViewObject(controller: controller, agent: agent)
    }
    func changeObject(object :NSObject) {
        agent.viewObjects.changeObject(object)
    }
    func addObject(object :NSObject,inSection section:Int) {
        agent.viewObjects.addObject(object, inSection: section)
    }
    func setDelegate(d :TableViewAgentDelegate!){
        _detegate = d
        
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
        agent.commonViewObject = d.respondsToSelector(NSSelectorFromString("commonViewObject:")) ? {o in
            return d.commonViewObject!(o)
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