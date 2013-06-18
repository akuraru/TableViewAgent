//
//  AdditionalCellStateShowEditing.m
//  TableViewAgent
//
//  Created by P.I.akura on 2013/06/18.
//  Copyright (c) 2013年 P.I.akura. All rights reserved.
//

#import "AdditionalCellStateShowEditing.h"

@implementation AdditionalCellStateShowEditing

- (BOOL)isShowAddCell:(BOOL)edting {
    return edting;
}

- (ChangeInState)changeInState:(BOOL)edting {
    return (edting == NO) ? ChangeInStateHide : ChangeInStateShow;
}
@end
