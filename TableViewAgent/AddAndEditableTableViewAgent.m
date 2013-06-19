//
// Created by P.I.akura on 2013/06/18.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AddAndEditableTableViewAgent.h"
#import "AdditionalCellStateAlways.h"
#import "AdditionalCellStateHideEditing.h"
#import "AdditionalCellStateShowEditing.h"

@implementation AddAndEditableTableViewAgent {
    NSString *additionalCellId;
    AdditionalCellState *state;
}
- (id)init {
    self = [super init];
    if (self) {
        state = [AdditionalCellStateAlways new];
    }
    return self;
}

- (void)setAdditionalCellId:(NSString *)aci {
    additionalCellId = aci;
}

- (void)setAdditionalCellMode:(AdditionalCellMode)mode {
    switch (mode) {
        case AdditionalCellModeNone: {
            state = [AdditionalCellStateAlways new];
        } break;
        case AdditionalCellModeHideEdting: {
            state = [AdditionalCellStateHideEditing new];
        } break;
        case AdditionalCellModeShowEdting: {
            state = [AdditionalCellStateShowEditing new];
        } break;
    }
}

- (void)addViewObject:(id)object {
    viewObjects = [viewObjects arrayByAddingObject:object];
    [self insertRowWithSection:0];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [super tableView:tableView numberOfRowsInSection:section] + [state isShowAddCell:self.editing];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isAdditionalCellOfIndexPath:indexPath]) {
        return [self createAdditionalCell:tableView];
    } else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (UITableViewCell *)createAdditionalCell:(UITableView *)tableView {
    return [tableView dequeueReusableCellWithIdentifier:additionalCellId];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    if ([self isAdditionalCellOfIndexPath:indexPath]) {
        if ([delegate respondsToSelector:@selector(didSelectAdditionalCell)]) {
            [delegate didSelectAdditionalCell];
        }
    }
}

- (BOOL)isAdditionalCellOfIndexPath:(NSIndexPath *)path {
    return [viewObjects count] == path.row;
}

- (void)setEditing:(BOOL)b {
    [[delegate tableView] setEditing:b animated:YES];
    [self setAddCellHide:[state changeInState:self.editing]];
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
    return [NSIndexPath indexPathForRow:[viewObjects count] inSection:0];
}

- (BOOL)editing {
    return [[delegate tableView] isEditing];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self isAdditionalCellOfIndexPath:indexPath] == NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        id viewObject = [self viewObjectWithIndex:indexPath];
        if ([delegate respondsToSelector:@selector(deleteCell:)]) {
            [delegate deleteCell:viewObject];
        }
        viewObjects = [viewObjects filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL (id e, id bindings) {
            return [e isEqual:viewObject] == NO;
        }]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end