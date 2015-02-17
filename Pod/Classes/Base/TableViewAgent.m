//
// Created by P.I.akura on 2013/06/15.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TableViewAgent.h"
#import "AgentViewObjectProtocol.h"
#import "TableViewAgentProtocol.h"

typedef struct {
    BOOL deleteCell                 : 1;
    BOOL insertCell                 : 1;
    BOOL sectionHeightForHeader     : 1;
    BOOL sectionHeader              : 1;
} HasSelectors;

@interface TableViewAgent () <UITableViewDataSource, UITableViewDelegate, TableViewAgentProtocol>
@end

@implementation TableViewAgent {
    HasSelectors hasSelectors;
}

- (id)init {
    self = [super init];
    if (self) {
        _editing = NO;
    }
    return self;
}

- (void)redraw {
    [[_delegate tableView] reloadData];
    [self setEditing:NO];
}

- (void)setViewObjects:(id <AgentViewObjectProtocol>)viewObjects {
    _viewObjects = viewObjects;
    viewObjects.agent = self;
}

- (id)viewObjectWithIndex:(NSIndexPath *)path {
    return [_viewObjects objectAtIndexPath:path];
}

- (void)setEditing:(BOOL)b {
    if ([self.viewObjects canEdit] && _editing != b) {
        _editing = b;
        [self.viewObjects setEditing:b];
        [[_delegate tableView] setEditing:!b animated:NO];
        [[_delegate tableView] setEditing:b animated:YES];
    }
}

#pragma mark -
#pragma mark change cell

- (void)deleteCell:(id <AgentViewObjectProtocol>)agentViewObject atIndexPath:(NSIndexPath *)indexPath {
    if ([self compareSectionCount:_viewObjects.sectionCount]) {
        [_delegate.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [_delegate.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)deleteSection:(id <AgentViewObjectProtocol>)agentViewObject atSection:(NSInteger)section {
    [self.delegate.tableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)deleteCells:(id <AgentViewObjectProtocol>)agentViewObject atSection:(NSInteger)section rows:(NSArray *)rows {
    if ([self compareSectionCount:_viewObjects.sectionCount]) {
        [_delegate.tableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [_delegate.tableView deleteRowsAtIndexPaths:[self indexPathsForSection:section rows:rows] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)insertCell:(id <AgentViewObjectProtocol>)agentViewObject atIndexPath:(NSIndexPath *)indexPath {
    if ([self compareSectionCount:_viewObjects.sectionCount]) {
        [_delegate.tableView insertSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [_delegate.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)insertSection:(id <AgentViewObjectProtocol>)agentViewObject atSection:(NSInteger)section {
    [[self.delegate tableView] insertSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)insertCells:(id <AgentViewObjectProtocol>)agentViewObject atSection:(NSInteger)section rows:(NSArray *)rows {
    if ([self compareSectionCount:_viewObjects.sectionCount]) {
        [_delegate.tableView insertSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [_delegate.tableView insertRowsAtIndexPaths:[self indexPathsForSection:section rows:rows] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)changeUpdateCell:(id <AgentViewObjectProtocol>)agentViewObject atIndexPath:(NSIndexPath *)indexPath {
    [_delegate.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)changeMoveCell:(id <AgentViewObjectProtocol>)agentViewObject fromIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = _delegate.tableView;
    [tableView beginUpdates];
    switch ([self compareSectionCount:_viewObjects.sectionCount]) {
        case NSOrderedSame :
            if ([_viewObjects countInSection:newIndexPath.section] == 1) {
                [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                [tableView insertSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            } else {
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            break;
        case NSOrderedAscending :
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSOrderedDescending :
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView insertSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
    [tableView endUpdates];
}

- (NSArray *)indexPathsForSection:(NSInteger)section rows:(NSArray *)rows {
    NSMutableArray *result = [NSMutableArray array];
    for (NSNumber *row in rows) {
        [result addObject:[NSIndexPath indexPathForRow:row.integerValue inSection:section]];
    }
    return result;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (hasSelectors.deleteCell) {
            id viewObject = [self viewObjectWithIndex:indexPath];
            [_delegate deleteCell:viewObject];
        }
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        if (hasSelectors.insertCell) {
            id viewObject = [self viewObjectWithIndex:indexPath];
            [self.delegate insertCell:viewObject];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id viewObject = [self viewObjectWithIndex:indexPath];
    NSString *cellIdentifier = [self.viewObjects cellIdentifierAtIndexPath:indexPath];
    Class cellClass = NSClassFromString(cellIdentifier);
    if ([cellClass respondsToSelector:@selector(heightFromViewObject:)]) {
        return [cellClass heightFromViewObject:viewObject];
    } else {
        return [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
    }
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.viewObjects didSelectRowAtIndexPath:indexPath];
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
    return [self.viewObjects canEditRowForIndexPath:indexPath];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.viewObjects titleForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
// todo: height
//    if (hasSelectors.sectionHeightForHeader) {
//        return [_delegate sectionHeightForHeader:[_viewObjects sectionObjects:section]];
//    } else if (hasSelectors.sectionHeader) {
//        return [_delegate sectionHeader:[_viewObjects sectionObjects:section]].frame.size.height;
//    }
    return -1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
// todo: header view
//    if (hasSelectors.sectionHeader) {
//        return [self.delegate sectionHeader:[_viewObjects sectionObjects:section]];
//    }
    return nil;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewObjects editingStyleForRowAtIndexPath:indexPath];
}

#pragma mark -

- (UITableViewCell *)createCell:(NSIndexPath *)indexPath {
    id viewObject = [self viewObjectWithIndex:indexPath];
    id cell = [[self.delegate tableView] dequeueReusableCellWithIdentifier:[self.viewObjects cellIdentifierAtIndexPath:indexPath]];
    [cell setViewObject:viewObject];
    return cell;
}

#pragma mark -

- (void)setDelegate:(id)d {
    _delegate = d;
    hasSelectors = [self createHasSelector:_delegate];
    [[d tableView] setDelegate:self];
    [[d tableView] setDataSource:self];
}

- (NSComparisonResult)compareSectionCount:(NSUInteger)count {
    return [@([_viewObjects sectionCount]) compare:@([_delegate.tableView numberOfSections])];
}

- (HasSelectors)createHasSelector:(id)d {
    HasSelectors s;
    s.deleteCell = [d respondsToSelector:@selector(deleteCell:)];
    s.insertCell = [d respondsToSelector:@selector(insertCell:)];
    s.sectionHeightForHeader = [d respondsToSelector:@selector(sectionHeightForHeader:)];
    s.sectionHeader = [d respondsToSelector:@selector(sectionHeader:)];
    return s;
}
@end