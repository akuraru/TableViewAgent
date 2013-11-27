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
#import "AdditionalCellStateNone.h"
#import "AdditionalCellStateAlways.h"
#import "AdditionalCellStateHideEditing.h"
#import "AdditionalCellStateShowEditing.h"

typedef struct {
    BOOL didSelectCell              : 1;
    BOOL deleteCell                 : 1;
    BOOL cellIdentifier             : 1;
    BOOL sectionTitle               : 1;
    BOOL addCellIdentifier          : 1;
    BOOL commonViewObject           : 1;
    BOOL didSelectAdditionalCell    : 1;
    BOOL addSectionTitle            : 1;
    BOOL addSectionHeightForHeader  : 1;
    BOOL addSectionHeader           : 1;
    BOOL sectionHeightForHeader     : 1;
    BOOL sectionHeader              : 1;
} HasSelectors;

@interface TableViewAgent () <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic) EditableState *editableState;
@property(nonatomic) AdditionalCellState *addState;
@end

@implementation TableViewAgent {
    HasSelectors hasSelectors;
}

- (id)init {
    self = [super init];
    if (self) {
        _addState = [AdditionalCellStateNone new];
        _editableState = [EditableStateNone new];
        _editing = NO;
    }
    return self;
}

- (void)redraw {
    [[_delegate tableView] reloadData];
    [self setEditing:NO];
}
- (void)setViewObjects:(id<AgentViewObjectProtocol>)viewObjects {
    _viewObjects = viewObjects;
    viewObjects.agent = self;
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
#pragma mark -
#pragma mark change cell

- (void)deleteCell:(NSIndexPath *)indexPath {
    if ([self compareSectionCount:_viewObjects.sectionCount]) {
        [_delegate.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [_delegate.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
- (void)insertCell:(NSIndexPath *)indexPath {
    if ([self compareSectionCount:_viewObjects.sectionCount]) {
        [_delegate.tableView insertSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [_delegate.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
- (void)changeUpdateCell:(NSIndexPath *)indexPath {
    [_delegate.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)changeMoveCell:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = _delegate.tableView;
    [tableView beginUpdates];
    switch ([self compareSectionCount:_viewObjects.sectionCount]) {
        case NSOrderedSame :
            if ([_viewObjects countInSection:newIndexPath.section] == 1) {
                [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                [tableView insertSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            } else {
                [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            }
            break;
        case NSOrderedAscending :
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSOrderedDescending :
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView insertSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
    [tableView endUpdates];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (hasSelectors.deleteCell) {
            id viewObject = [self viewObjectWithIndex:indexPath];
            [_delegate deleteCell:viewObject];
        }
        [_viewObjects removeObjectAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isAdditionalSection:indexPath.section]) {
        return [[tableView dequeueReusableCellWithIdentifier:[_delegate addCellIdentifier]] frame].size.height;
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

    if ([self isAdditionalSection:indexPath.section]) {
        if (hasSelectors.didSelectAdditionalCell) {
            [_delegate didSelectAdditionalCell];
        }
    } else {
        if (hasSelectors.didSelectCell) {
            [_delegate didSelectCell:[self viewObjectWithIndex:indexPath]];
        }
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self isAdditionalSection:section]) {
        return 1;
    } else {
        return [_viewObjects countInSection:section];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _viewObjects.sectionCount + [_addState isShowAddCell:_editing];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isAdditionalSection:indexPath.section]) {
        return [self createAdditionalCell:tableView];
    } else {
        return [self createCell:indexPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return _editableState.canEdit && [self isAdditionalSection:indexPath.section] == NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([self isAdditionalSection:section]) {
        if (hasSelectors.addSectionTitle) {
            return [_delegate addSectionTitle];
        }
    } else if (hasSelectors.sectionTitle) {
        return [_delegate sectionTitle:[_viewObjects sectionObjects:section]];
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self isAdditionalSection:section]) {
        if (hasSelectors.addSectionHeightForHeader) {
            return [_delegate addSectionHeightForHeader];
        } else if (hasSelectors.addSectionHeader) {
            return [_delegate addSectionHeader].frame.size.height;
        }
    } else {
        if (hasSelectors.sectionHeightForHeader) {
            return [_delegate sectionHeightForHeader:[_viewObjects sectionObjects:section]];
        } else if (hasSelectors.sectionHeader) {
            return [_delegate sectionHeader:[_viewObjects sectionObjects:section]].frame.size.height;
        }
    }
    return -1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self isAdditionalSection:section]) {
        if (hasSelectors.addSectionHeader) {
            return [_delegate addSectionHeader];
        }
    } else if (hasSelectors.sectionHeader) {
        return [_delegate sectionHeader:[_viewObjects sectionObjects:section]];
    }

    return nil;
}
#pragma mark -
- (UITableViewCell *)createAdditionalCell:(UITableView *)tableView {
    return [tableView dequeueReusableCellWithIdentifier:[_delegate addCellIdentifier]];
}

- (UITableViewCell *)createCell:(NSIndexPath *)indexPath {
    id viewObject = [self viewObjectWithIndex:indexPath];
    id cell = [self dequeueCell:indexPath];
    if (hasSelectors.commonViewObject) {
        [cell setViewObject:viewObject common:[_delegate commonViewObject:viewObject]];
    } else {
        [cell setViewObject:viewObject];
    }
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
    hasSelectors = [self createHasSelector:_delegate];
    [[d tableView] setDelegate:self];
    [[d tableView] setDataSource:self];
}

- (UITableViewCell *)dequeueCell:(NSIndexPath *)indexPath {
    id viewObject = [self viewObjectWithIndex:indexPath];
    return [[_delegate tableView] dequeueReusableCellWithIdentifier:[_delegate cellIdentifier:viewObject]];
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
    }
}

- (EditableState *)createEditableMode:(EditableMode)mode {
    switch (mode) {
        case EditableModeNone :
            return [EditableStateNone new];
        case EditableModeEnable :
            return [EditableStateEnadle new];
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
    [[_delegate tableView] deleteSections:[NSIndexSet indexSetWithIndex:[self sectionOfAddCell]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)showAddCell {
    [[_delegate tableView] insertSections:[NSIndexSet indexSetWithIndex:[self sectionOfAddCell]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (BOOL)isAdditionalSection:(NSInteger)section {
    return [_viewObjects sectionCount] == section;
}

- (NSInteger)sectionOfAddCell {
    return [_viewObjects sectionCount];
}

- (BOOL)compareSectionCount:(NSUInteger)count {
    return [@([_viewObjects sectionCount]) compare:@([_delegate.tableView numberOfSections] - [_addState isShowAddCell:_editing])];
}
- (HasSelectors)createHasSelector:(id)d {
    HasSelectors s;
    s.didSelectCell = [d respondsToSelector:@selector(didSelectCell:)];
    s.deleteCell = [d respondsToSelector:@selector(deleteCell:)];
    s.cellIdentifier = [d respondsToSelector:@selector(cellIdentifier:)];
    s.cellIdentifier = [d respondsToSelector:@selector(commonViewObject:)];
    s.sectionTitle = [d respondsToSelector:@selector(sectionTitle:)];
    s.addCellIdentifier = [d respondsToSelector:@selector(addCellIdentifier)];
    s.didSelectAdditionalCell = [d respondsToSelector:@selector(didSelectAdditionalCell)];
    s.addSectionTitle = [d respondsToSelector:@selector(addSectionTitle)];
    s.addSectionHeightForHeader = [d respondsToSelector:@selector(addSectionHeightForHeader)];
    s.addSectionHeader = [d respondsToSelector:@selector(addSectionHeader)];
    s.sectionHeightForHeader = [d respondsToSelector:@selector(sectionHeightForHeader:)];
    s.sectionHeader = [d respondsToSelector:@selector(sectionHeader:)];
    return s;
}
@end