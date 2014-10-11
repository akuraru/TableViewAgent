//
//  AdditionalCellState.swift
//  TableViewAgent
//
//  Created by akuraru on 2014/07/29.
//  Copyright (c) 2014年 P.I.akura. All rights reserved.
//

import Foundation

enum ChangeInState {
    case None, Hide, Show
}

enum AdditionalCellState {
    case None, Always, HideEditing, ShowEditing
    func isShowAddCell(editing :Bool) -> Bool {
        switch self {
        case .None: return false
        case .Always: return true
        case .ShowEditing: return editing
        case .HideEditing: return !editing
        }
    }
    
    func changeInState(editing :Bool) -> ChangeInState {
        switch self {
        case .None: return .None
        case .Always: return .None
        case .ShowEditing: return (editing) ? .Show : .Hide
        case .HideEditing: return (editing) ? .Hide : .Show
        }
    }

}