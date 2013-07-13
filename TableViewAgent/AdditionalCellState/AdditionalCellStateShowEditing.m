//
//  AdditionalCellStateShowEditing.m
//  TableViewAgent
//
//  Created by P.I.akura on 2013/06/18.
//  Copyright (c) 2013年 P.I.akura. All rights reserved.
//

#import "AdditionalCellStateShowEditing.h"

@implementation AdditionalCellStateShowEditing

- (BOOL)isShowAddCell:(BOOL) editing {
    return editing;
}

- (ChangeInState)changeInState:(BOOL) editing {
    return (editing == NO) ? ChangeInStateHide : ChangeInStateShow;
}

@end
