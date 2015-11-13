//
// Created by P.I.akura on 2013/06/15.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TableViewAgent.h"
#import "AgentViewObjectProtocol.h"
#import "TableViewAgentProtocol.h"
#import "TableViewAgentSectionViewDelegate.h"

@interface TableViewAgent () <UITableViewDataSource, UITableViewDelegate, TableViewAgentProtocol>
@end

@implementation TableViewAgent

- (id)init {
    self = [super init];
    if (self) {
        _editing = NO;
    }
    return self;
}

- (void)redraw {
    [self.tableView reloadData];
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
        [self.tableView setEditing:!b animated:NO];
        [self.tableView setEditing:b animated:YES];
    }
}

#pragma mark -
#pragma mark change cell

- (void)deleteCell:(id <AgentViewObjectProtocol>)agentViewObject atIndexPath:(NSIndexPath *)indexPath {
    if ([self compareSectionCount:_viewObjects.sectionCount]) {
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)deleteSection:(id <AgentViewObjectProtocol>)agentViewObject atSection:(NSInteger)section {
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)deleteCells:(id <AgentViewObjectProtocol>)agentViewObject atSection:(NSInteger)section rows:(NSArray *)rows {
    if ([self compareSectionCount:_viewObjects.sectionCount]) {
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [self.tableView deleteRowsAtIndexPaths:[self indexPathsForSection:section rows:rows] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)insertCell:(id <AgentViewObjectProtocol>)agentViewObject atIndexPath:(NSIndexPath *)indexPath {
    if ([self compareSectionCount:_viewObjects.sectionCount]) {
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)insertSection:(id <AgentViewObjectProtocol>)agentViewObject atSection:(NSInteger)section {
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)insertCells:(id <AgentViewObjectProtocol>)agentViewObject atSection:(NSInteger)section rows:(NSArray *)rows {
    if ([self compareSectionCount:_viewObjects.sectionCount]) {
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [self.tableView insertRowsAtIndexPaths:[self indexPathsForSection:section rows:rows] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)changeUpdateCell:(id <AgentViewObjectProtocol>)agentViewObject atIndexPath:(NSIndexPath *)indexPath {
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)changeMoveCell:(id <AgentViewObjectProtocol>)agentViewObject fromIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
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
        [self.viewObjects editingDeleteForRowAtIndexPath:indexPath];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        [self.viewObjects editingInsertForRowAtIndexPath:indexPath];
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

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewObjects canMoveRowAtIndexPath:indexPath];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.viewObjects titleForHeaderInSection:section];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [self.viewObjects titleForFooterInSection:section];;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSString *headerIdentifier = [self.viewObjects headerIdentifierInSection:section];
    if (headerIdentifier) {
        Class sectionViewClass = NSClassFromString(headerIdentifier);
        if (sectionViewClass) {
            id sectionObject = [self.viewObjects sectionObjectInSection:section];
            return [sectionViewClass heightFromSectionObject:sectionObject];
        } else {
            return [[self tableView:tableView viewForHeaderInSection:section] frame].size.height;
        }
    } else {
        return -1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *headerIdentifier = [self.viewObjects headerIdentifierInSection:section];
    if (headerIdentifier) {
        UITableViewHeaderFooterView<TableViewAgentSectionViewDelegate> *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
        id sectionObject = [self.viewObjects sectionObjectInSection:section];
        [view setSectionObject:sectionObject];
        return view;
    } else {
        return nil;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewObjects editingStyleForRowAtIndexPath:indexPath];
}

#pragma mark -

- (UITableViewCell *)createCell:(NSIndexPath *)indexPath {
    id viewObject = [self viewObjectWithIndex:indexPath];
    id cell = [self.tableView dequeueReusableCellWithIdentifier:[self.viewObjects cellIdentifierAtIndexPath:indexPath]];
    [cell setViewObject:viewObject];
    return cell;
}

#pragma mark -

- (void)setTableView:(UITableView *)tableView {
    _tableView = tableView;
    [tableView setDelegate:self];
    [tableView setDataSource:self];
}

- (NSComparisonResult)compareSectionCount:(NSUInteger)count {
    return [@([_viewObjects sectionCount]) compare:@([self.tableView numberOfSections])];
}

//- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView __TVOS_PROHIBITED { return @[]; }
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index __TVOS_PROHIBITED { return 0; }
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {}
@end
