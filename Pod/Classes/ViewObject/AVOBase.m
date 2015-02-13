//
// Created by P.I.akura on 2013/08/18.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AVOBase.h"
#import "EditableStateNone.h"
#import "EditableStateEnadle.h"
#import "EditableStateEditingEnable.h"
#import "EditableStateEditingNonEnable.h"

@interface AVOBase ()
@property(nonatomic) EditableState *editableState;
@end

@implementation AVOBase
- (instancetype)init {
    self = [super init];
    if (self) {
        _editableState = [EditableStateNone new];
    }
    return self;
}

- (BOOL)canEditRowForIndexPath:(NSIndexPath *)indexPath {
    return [self canEdit];
}

- (BOOL)canEdit {
    return self.editableState.canEdit;
}

- (void)setEditableMode:(EditableMode)mode {
    _editableState = [self createEditableMode:mode];
}

- (EditableState *)createEditableMode:(EditableMode)mode {
    switch (mode) {
        case EditableModeNone :
            return [EditableStateNone new];
        case EditableModeEnable :
            return [EditableStateEnadle new];
        case EditableModeEditingEnable:
            return [EditableStateEditingEnable new];
        case EditableModeEditingNonEnable:
            return [EditableStateEditingNonEnable new];
        default:
            return nil;
    }
}

- (UITableViewCellEditingStyle)editingStyleForRowAtIndexPath:(NSIndexPath *)path {
    return UITableViewCellEditingStyleDelete;
}
@end