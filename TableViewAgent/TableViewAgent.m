//
// Created by P.I.akura on 2013/06/15.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TableViewAgent.h"
#import "EditableStateNone.h"
#import "EditableStateEnadle.h"
#import "AgentViewObjectProtocol.h"

@interface TableViewAgent ()
@property (nonatomic) EditableState *editableState;
@end

@implementation TableViewAgent

- (id)init {
    self = [super init];
    if (self) {
        _editableState = [EditableStateNone new];
        _editing = NO;
    }
    return self;
}

- (void)redraw {
    [[_delegate tableView] reloadRowsAtIndexPaths:[[_delegate tableView] indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self setEditing:NO];
}

- (void)setEditableMode:(EditableMode)mode {
    _editableState = [self createEditableMode:mode];
}

- (id)viewObjectWithIndex:(NSIndexPath *)path {
    return [_viewObjects objectAtIndexPath:path];
}
- (void)setEditing:(BOOL)b {
    if (_editableState.canEdit && _editing != b) {
        _editing = b;
        [[_delegate tableView] setEditing:!b animated:NO];
        [[_delegate tableView] setEditing:b animated:YES];
    }
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([_delegate respondsToSelector:@selector(deleteCell:)]) {
            id viewObject = [self viewObjectWithIndex:indexPath];
            [_delegate deleteCell:viewObject];
        }
        switch ([_viewObjects removeObjectAtIndexPath:indexPath]) {
            case DeleteViewObjectTypeSection :
                [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            case DeleteViewObjectTypeCell :
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell = [self dequeueCell:indexPath];
    if ([cell respondsToSelector:@selector(heightFromViewObject:)]) {
        return [cell heightFromViewObject:[self viewObjectWithIndex:indexPath]];
    } else {
        return [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
    }
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ([_delegate respondsToSelector:@selector(didSelectCell:)]) {
        [_delegate didSelectCell:[self viewObjectWithIndex:indexPath]];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_viewObjects countInSection:section];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _viewObjects.sectionCount;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self createCell:indexPath];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return  _editableState.canEdit;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([_delegate respondsToSelector:@selector(sectionTitle:)]) {
        return [_delegate sectionTitle:[_viewObjects sectionObjects:section]];
    } else {
        return @"";
    }
}
#pragma mark -
- (UITableViewCell *)createCell:(NSIndexPath *)indexPath {
    id viewObject = [self viewObjectWithIndex:indexPath];
    id cell = [self dequeueCell:indexPath];
    [cell setViewObject:viewObject];
    return cell;
}

#pragma mark -

- (void)insertRowWithSection:(NSInteger)section createSection:(BOOL)b {
    if (b) {
        [[_delegate tableView] insertSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [[_delegate tableView] insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[_viewObjects countInSection:section] - 1 inSection:section]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
- (void)setDelegate:(id)d {
    _delegate = d;
    [[d tableView] setDelegate:self];
    [[d tableView] setDataSource:self];
}
- (UITableViewCell *)dequeueCell:(NSIndexPath *)indexPath {
    id viewObject = [self viewObjectWithIndex:indexPath];
    return [[_delegate tableView] dequeueReusableCellWithIdentifier:[_delegate cellIdentifier:viewObject]];
}

- (EditableState *)createEditableMode:(EditableMode)mode {
    switch (mode) {
        case EditableModeNone : return [EditableStateNone new];
        case EditableModeEnable : return [EditableStateEnadle new];
    }
}

@end