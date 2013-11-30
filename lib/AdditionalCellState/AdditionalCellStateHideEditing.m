//
//  AdditionalCellStateHideEditing.m
//  TableViewAgent
//
//  Created by P.I.akura on 2013/06/18.
//  Copyright (c) 2013年 P.I.akura. All rights reserved.
//

#import "AdditionalCellStateHideEditing.h"

@implementation AdditionalCellStateHideEditing

- (BOOL)isShowAddCell:(BOOL) editing {
    return editing == NO;
}

- (ChangeInState)changeInState:(BOOL) editing {
    return (editing) ? ChangeInStateHide : ChangeInStateShow;
}

@end
