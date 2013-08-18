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
#import "AgentViewObjectProtocol.h"

@interface TableViewAgent ()
@property (nonatomic) AdditionalCellState *addState;
@property (nonatomic) EditableState *editableState;
@end

@implementation TableViewAgent

- (id)init {
    self = [super init];
    if (self) {
        _addState = [AdditionalCellStateNone new];
        _editableState = [EditableStateNone new];
        _additionalCellId = nil;
        _editing = NO;
    }
    return self;
}

- (void)redraw {
    [[_delegate tableView] reloadRowsAtIndexPaths:[[_delegate tableView] indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self setEditing:NO];
}

- (void)setAdditionalCellMode:(AdditionalCellMode)mode {
    _addState = [self createAdditionalCellMode:mode];
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
        [self setAddCellHide:[_addState changeInState:_editing]];
    }
}

- (void)addViewObject:(id)object {
    [_viewObjects addObject:object];
    [self insertRowWithSection:0];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([_delegate respondsToSelector:@selector(deleteCell:)]) {
            id viewObject = [self viewObjectWithIndex:indexPath];
            [_delegate deleteCell:viewObject];
        }
        [_viewObjects removeObjectAtIndexPath:indexPath];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isAdditionalCellOfIndexPath:indexPath]) {
        return [[tableView dequeueReusableCellWithIdentifier:_additionalCellId] frame].size.height;
    } else {
        id cell = [self dequeueCell:indexPath];
        if ([cell respondsToSelector:@selector(heightFromViewObject:)]) {
            return [cell heightFromViewObject:[self viewObjectWithIndex:indexPath]];
        } else {
            return [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
        }
    }
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ([self isAdditionalCellOfIndexPath:indexPath]) {
        if ([_delegate respondsToSelector:@selector(didSelectAdditionalCell)]) {
            [_delegate didSelectAdditionalCell];
        }
    } else {
        if ([_delegate respondsToSelector:@selector(didSelectCell:)]) {
            [_delegate didSelectCell:[self viewObjectWithIndex:indexPath]];
        }
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_viewObjects countInSection:section] + [_addState isShowAddCell:_editing];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isAdditionalCellOfIndexPath:indexPath]) {
        return [self createAdditionalCell:tableView];
    } else {
        return [self createCell:indexPath];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([_viewObjects respondsToSelector:@selector(sectionCount)]) {
        return _viewObjects.sectionCount;
    } else {
        return 1;
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return  _editableState.canEdit && [self isAdditionalCellOfIndexPath:indexPath] == NO;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [@(section) stringValue];
}
#pragma mark -
- (UITableViewCell *)createCell:(NSIndexPath *)indexPath {
    id viewObject = [self viewObjectWithIndex:indexPath];
    id cell = [self dequeueCell:indexPath];
    [cell setViewObject:viewObject];
    return cell;
}

- (UITableViewCell *)createAdditionalCell:(UITableView *)tableView {
    return [tableView dequeueReusableCellWithIdentifier:_additionalCellId];
}

#pragma mark -


- (void)insertRowWithSection:(NSInteger)section {
    [[_delegate tableView] insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[_viewObjects countInSection:section] - 1 inSection:section]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (BOOL)isAdditionalCellOfIndexPath:(NSIndexPath *)path {
    return [_viewObjects countInSection:path.section] == path.row;
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

- (AdditionalCellState *)createAdditionalCellMode:(AdditionalCellMode)mode {
    switch (mode) {
        case AdditionalCellModeNone : return [AdditionalCellStateNone new];
        case AdditionalCellModeAlways : return [AdditionalCellStateAlways new];
        case AdditionalCellModeHideEditing: return [AdditionalCellStateHideEditing new];
        case AdditionalCellModeShowEditing: return [AdditionalCellStateShowEditing new];
    }
}

- (EditableState *)createEditableMode:(EditableMode)mode {
    switch (mode) {
        case EditableModeNone : return [EditableStateNone new];
        case EditableModeEnable : return [EditableStateEnadle new];
    }
}

- (void)setAddCellHide:(ChangeInState)cis {
    switch (cis) {
        case ChangeInStateNone: {
        } break;
        case ChangeInStateHide: {
            [self hideAddCell];
        } break;
        case ChangeInStateShow: {
            [self showAddCell];
        } break;
    }
}

- (void)hideAddCell {
    [[_delegate tableView] deleteRowsAtIndexPaths:@[[self indexPathAddCell]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)showAddCell {
    [[_delegate tableView] insertRowsAtIndexPaths:@[[self indexPathAddCell]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSIndexPath *)indexPathAddCell {
    if ([_viewObjects respondsToSelector:@selector(indexPathAddCell)]) {
        return _viewObjects.indexPathAddCell;
    } else {
        return [NSIndexPath indexPathForRow:[_viewObjects countInSection:0] inSection:0];
    }
}
@end