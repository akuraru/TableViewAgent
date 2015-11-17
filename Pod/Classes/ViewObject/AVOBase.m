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

- (NSString *)cellIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellIdentifier([self objectAtIndexPath:indexPath]);
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelectCell) {
        self.didSelectCell([self objectAtIndexPath:indexPath]);
    }
}

- (NSString *)titleForHeaderInSection:(NSInteger)section {
    if (self.headerTitleForSectionObject) {
        return self.headerTitleForSectionObject([self sectionObjectInSection:section]);
    }
    return nil;
}

- (NSString *)titleForFooterInSection:(NSInteger)section {
    if (self.footerTitleForSectionObject) {
        return self.footerTitleForSectionObject([self sectionObjectInSection:section]);
    }
    return nil;
}

- (NSString *)headerIdentifierInSection:(NSInteger)section {
    if (self.headerIdentifierForSectionObject) {
        return self.headerIdentifierForSectionObject([self sectionObjectInSection:section]);
    }
    return nil;
}

- (NSString *)footerIdentifierInSection:(NSInteger)section {
    if (self.footerIdentifierForSectionObject) {
        return self.footerIdentifierForSectionObject([self sectionObjectInSection:section]);
    }
    return nil;
}

- (void)editingDeleteForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.editingDeleteViewObject) {
        self.editingDeleteViewObject([self objectAtIndexPath:indexPath]);
    }
}

- (void)editingInsertForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self editingInsertViewObject]) {
        self.editingInsertViewObject([self objectAtIndexPath:indexPath]);
    }
}

// need override
- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (id)sectionObjectInSection:(NSInteger)section {
    return nil;
}
@end