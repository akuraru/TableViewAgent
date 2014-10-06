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
    let agent :TableViewAgent<NSObject>
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
        agent.delegate = d
    }
    func setEditableModel(mode :EditableMode) {
        agent.editableState = createEditableState(mode)
    }
    func createEditableState(mode :EditableMode) -> EditableState {
        switch mode {
        case .Enable: return EditableStateEnadle()
        case .None: return EditableStateNone()
        }
    }
    func setAddMode(mode :AdditionalCellMode) {
        agent.addState = createAddState(mode)
    }
    func createAddState(mode :AdditionalCellMode) -> AdditionalCellState {
        switch mode {
        case .None: return AdditionalCellStateNone();
        case .HideEditing: return AdditionalCellStateHideEditing();
        case .ShowEditing: return AdditionalCellStateShowEditing();
        case .Always: return AdditionalCellStateAlways();
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