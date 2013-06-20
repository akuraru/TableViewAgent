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
    return viewObjects[path.row];
}

- (void)setAdditionalCellId:(NSString *)aci {
    additionalCellId = aci;
}

- (void)addViewObject:(id)object {
    viewObjects = [viewObjects arrayByAddingObject:object];
    [self insertRowWithSection:0];
}

- (UITableViewCell *)createAdditionalCell:(UITableView *)tableView {
    return [tableView dequeueReusableCellWithIdentifier:additionalCellId];
}

- (BOOL)isAdditionalCellOfIndexPath:(NSIndexPath *)path {
    return [viewObjects count] == path.row;
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
    return [NSIndexPath indexPathForRow:[viewObjects count] inSection:0];
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
        viewObjects = [viewObjects filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL (id e, id bindings) {
            return [e isEqual:viewObject] == NO;
        }]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [viewObjects count] + [addState isShowAddCell:self.editing];
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

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    id cell = [[delegate tableView] dequeueReusableCellWithIdentifier:cellId];
//    if ([cell respondsToSelector:@selector(heightFromViewObject:)]) {
//        return [cell heightFromViewObject:[self viewObjectWithIndex:indexPath]];
//    } else {
//        return [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
//    }
//}
@end
