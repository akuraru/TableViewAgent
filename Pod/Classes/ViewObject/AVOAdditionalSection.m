//
// Created by P.I.akura on 2013/08/18.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AVOAdditionalSection.h"
#import "TableViewAgentProtocol.h"
#import "AdditionalCellState.h"
#import "AdditionalCellStateNone.h"
#import "AdditionalCellStateAlways.h"
#import "AdditionalCellStateHideEditing.h"
#import "AdditionalCellStateShowEditing.h"


@interface AVOAdditionalSection ()
@property(nonatomic) AdditionalCellState *addState;
@end

@implementation AVOAdditionalSection

- (id)initWithViewObject:(id)viewObject {
    self = [super init];
    if (self) {
        self.viewObject = viewObject;
        _addState = [AdditionalCellStateNone new];

    }
    return self;
}

- (NSIndexPath *)indexPathForObject:(id)object {
    if ([self.viewObject isEqual:object]) {
        return [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return nil;
}

- (NSUInteger)countInSection:(NSUInteger)section {
    return 1;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    return self.viewObject;
}

- (NSUInteger)sectionCount {
    return [self.addState isShowAddCell:self.editing] ? 1 : 0;
}

- (BOOL)canEditRowForIndexPath:(NSIndexPath *)indexPath {
    return self.editing;
}

- (BOOL)canEdit {
    return NO;
}

- (void)setEditing:(BOOL)editing {
    _editing = editing;
    [self setAddCellHide:[self.addState changeInState:editing]];
}

- (void)setAdditionalCellMode:(AdditionalCellMode)mode {
    _addState = [self createAdditionalCellMode:mode];
}

- (AdditionalCellState *)createAdditionalCellMode:(AdditionalCellMode)mode {
    switch (mode) {
        case AdditionalCellModeNone :
            return [AdditionalCellStateNone new];
        case AdditionalCellModeAlways :
            return [AdditionalCellStateAlways new];
        case AdditionalCellModeHideEditing:
            return [AdditionalCellStateHideEditing new];
        case AdditionalCellModeShowEditing:
            return [AdditionalCellStateShowEditing new];
        default:
            return nil;
    }
}

- (void)setAddCellHide:(ChangeInState)cis {
    switch (cis) {
        case ChangeInStateNone:
            break;
        case ChangeInStateHide:
            [self hideAddCell];
            break;
        case ChangeInStateShow:
            [self showAddCell];
            break;
    }
}

- (void)hideAddCell {
    [self.agent deleteSection:self atSection:0];
}

- (void)showAddCell {
    [self.agent insertSection:self atSection:0];
}

- (UITableViewCellEditingStyle)editingStyleForRowAtIndexPath:(NSIndexPath *)path {
    return UITableViewCellEditingStyleInsert;
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

- (NSString *)headerIdentifierInSection:(NSInteger)section {
    if (self.headerIdentifierForSectionObject) {
        return self.headerIdentifierForSectionObject([self sectionObjectInSection:section]);
    }
    return nil;
}

- (id)sectionObjectInSection:(NSInteger)section {
    return self.viewObject;
}
@end