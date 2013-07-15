//
// Created by P.I.akura on 2013/06/15.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TableViewAgent.h"
#import "AdditionalCellStateNone.h"
#import "AdditionalCellStateAlways.h"
#import "AdditionalCellStateHideEditing.h"
#import "AdditionalCellStateShowEditing.h"
#import "EditableStateNone.h"
#import "EditableStateEnadle.h"

@implementation TableViewAgent

- (id)init {
    self = [super init];
    if (self) {
        addState = [AdditionalCellStateNone new];
        editableState = [EditableStateNone new];
    }
    return self;
}

- (void)setDelegate:(id)d {
    delegate = d;
    [[d tableView] setDelegate:self];
    [[d tableView] setDataSource:self];
}
- (UITableViewCell *)dequeueCell:(NSIndexPath *)indexPath {
    id viewObject = [self viewObjectWithIndex:indexPath];
    return [[delegate tableView] dequeueReusableCellWithIdentifier:[delegate cellIdentifier:viewObject]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id viewObject = [self viewObjectWithIndex:indexPath];
    id cell = [self dequeueCell:indexPath];
    [cell setViewObject:viewObject];
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)redraw {
    [[delegate tableView] reloadRowsAtIndexPaths:[[delegate tableView] indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self setEditing:NO];
}

- (void)insertRowWithSection:(NSInteger)section {
    [[delegate tableView] insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.viewObjects count] - 1 inSection:section]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)setAdditionalCellMode:(AdditionalCellMode)mode {
    switch (mode) {
        case AdditionalCellModeNone : {
            addState = [AdditionalCellStateNone new];
        } break;
        case AdditionalCellModeAlways : {
            addState = [AdditionalCellStateAlways new];
        } break;
        case AdditionalCellModeHideEditing: {
            addState = [AdditionalCellStateHideEditing new];
        } break;
        case AdditionalCellModeShowEditing: {
            addState = [AdditionalCellStateShowEditing new];
        } break;
        case AdditionalCellModeHideEdting: {
            addState = [AdditionalCellStateHideEditing new];
        } break;
        case AdditionalCellModeShowEdting: {
            addState = [AdditionalCellStateShowEditing new];
        } break;
    }
}
- (void)setEditableMode:(EditableMode)mode {
    switch (mode) {
        case EditableModeNone : {
            editableState = [EditableStateNone new];
        } break;
        case EditableModeEnable : {
            editableState = [EditableStateEnadle new];
        } break;
    }
}

- (override_id)viewObjectWithIndex:(NSIndexPath *)indexPath {
    return nil;
}
- (override_void)setEditing:(BOOL)b {
    [[delegate tableView] setEditing:b animated:YES];
}
@end