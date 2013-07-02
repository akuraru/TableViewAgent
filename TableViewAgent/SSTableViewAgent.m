//
//  SSTableViewAgent.m
//  TableViewAgent
//
//  Created by P.I.akura on 2013/06/19.
//  Copyright (c) 2013年 P.I.akura. All rights reserved.
//

#import "SSTableViewAgent.h"
#import "EditableState.h"
#import "AdditionalCellState.h"

@implementation SSTableViewAgent {
    NSString *additionalCellId;
    BOOL editing;
    UIView *headerView;
}

- (id)init {
    self = [super init];
    if (self) {
        additionalCellId = nil;
        editing = NO;
    }
    return self;
}

- (id)viewObjectWithIndex:(NSIndexPath *)path {
    return self.viewObjects[path.row];
}

- (void)setAdditionalCellId:(NSString *)aci {
    additionalCellId = aci;
}

- (void)addViewObject:(id)object {
    self.viewObjects = [self.viewObjects arrayByAddingObject:object];
    [self insertRowWithSection:0];
}
- (void)setHeaderView:(UIView *)hv {
    headerView = hv;
}

- (UITableViewCell *)createAdditionalCell:(UITableView *)tableView {
    return [tableView dequeueReusableCellWithIdentifier:additionalCellId];
}

- (BOOL)isAdditionalCellOfIndexPath:(NSIndexPath *)path {
    return [self.viewObjects count] == path.row;
}

- (void)setEditing:(BOOL)b {
    if (editableState.canEdit && editing != b) {
        editing = b;
        [[delegate tableView] setEditing:!b animated:NO];
        [[delegate tableView] setEditing:b animated:YES];
        [self setAddCellHide:[addState changeInState:self.editing]];
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
    [[delegate tableView] deleteRowsAtIndexPaths:@[[self indexPathAddCell]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)showAddCell {
    [[delegate tableView] insertRowsAtIndexPaths:@[[self indexPathAddCell]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSIndexPath *)indexPathAddCell {
    return [NSIndexPath indexPathForRow:[self.viewObjects count] inSection:0];
}

- (BOOL)editing {
    return editing;
}

#pragma mark -
#pragma mark UITableViewDelegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        id viewObject = [self viewObjectWithIndex:indexPath];
        if ([delegate respondsToSelector:@selector(deleteCell:)]) {
            [delegate deleteCell:viewObject];
        }
        self.viewObjects = [self.viewObjects filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL (id e, id bindings) {
            return [e isEqual:viewObject] == NO;
        }]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewObjects count] + [addState isShowAddCell:self.editing];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isAdditionalCellOfIndexPath:indexPath]) {
        return [self createAdditionalCell:tableView];
    } else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return  editableState.canEdit && [self isAdditionalCellOfIndexPath:indexPath] == NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    if ([self isAdditionalCellOfIndexPath:indexPath]) {
        if ([delegate respondsToSelector:@selector(didSelectAdditionalCell)]) {
            [delegate didSelectAdditionalCell];
        }
    } else {
        if ([delegate respondsToSelector:@selector(didSelectCell:)]) {
            [delegate didSelectCell:[self viewObjectWithIndex:indexPath]];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isAdditionalCellOfIndexPath:indexPath]) {
        return [[tableView dequeueReusableCellWithIdentifier:additionalCellId] frame].size.height;
    } else {
        id cell = [self dequeueCell:indexPath];
    if ([cell respondsToSelector:@selector(heightFromViewObject:)]) {
        return [cell heightFromViewObject:[self viewObjectWithIndex:indexPath]];
    } else {
        return [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
    }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return headerView.frame.size.height;
}

@end
