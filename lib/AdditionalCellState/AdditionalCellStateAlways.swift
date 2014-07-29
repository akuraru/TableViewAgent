//
//  AdditionalCellStateAlways.swift
//  TableViewAgent
//
//  Created by akuraru on 2014/07/29.
//  Copyright (c) 2014年 P.I.akura. All rights reserved.
//

import Foundation

class AdditionalCellStateAlways : AdditionalCellState {
    override func isShowAddCell(editing :Bool) -> Bool {
    return true
    }
}