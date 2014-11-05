//
//  EditableState.swift
//  TableViewAgent
//
//  Created by akuraru on 2014/07/29.
//  Copyright (c) 2014 P.I.akura. All rights reserved.
//

import Foundation

enum EditableState {
    case Enable, None
    func canEdit() -> Bool {
        switch self {
        case .Enable: return true
        case .None: return false
        }
    }
}
