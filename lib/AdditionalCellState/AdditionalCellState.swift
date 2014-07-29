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

class AdditionalCellState :NSObject {
    func isShowAddCell(editing :Bool) -> Bool {
        return false
    }
    
    func changeInState(editing :Bool) -> Int {
        return 0;
    }

}