//
//  AdditionalCellState.m
//  TableViewAgent
//
//  Created by P.I.akura on 2013/06/18.
//  Copyright (c) 2013年 P.I.akura. All rights reserved.
//

#import "AdditionalCellState.h"

@implementation AdditionalCellState

- (BOOL)isShowAddCell:(BOOL) editing {
    return NO;
}

- (ChangeInState)changeInState:(BOOL) editing {
    return ChangeInStateNone;
}

@end
