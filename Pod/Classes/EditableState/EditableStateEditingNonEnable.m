//
//  EditableStateEnadle.m
//  TableViewAgent
//
//  Created by P.I.akura on 2013/06/20.
//  Copyright (c) 2013年 P.I.akura. All rights reserved.
//

#import "EditableStateEditingNonEnable.h"

@implementation EditableStateEditingNonEnable

- (BOOL)canEdit {
    return YES;
}

- (BOOL)editableForEditing:(BOOL)editing {
    return !editing;
}

@end
