//
// Created by P.I.akura on 2013/06/18.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AddAndEditableTableViewAgent.h"


@implementation AddAndEditableTableViewAgent {
    NSString *additionalCellId;
}

- (void)setAdditionalCellId:(NSString *)aci {
    additionalCellId = aci;
}
- (void)addViewObject:(id)object {
    viewObjects = [viewObjects arrayByAddingObject:object];
    [self insertRowWithSection:0];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [super tableView:tableView numberOfRowsInSection:section] + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isAdditionalCellOfIndexPath:indexPath]) {
        return [self createAdditionalCell:tableView];
    } else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (void)redraw {
    for (id cell in [[delegate tableView] visibleCells]) {
        NSIndexPath *indexPath = [[delegate tableView] indexPathForCell:cell];
        if ([self isAdditionalCellOfIndexPath:indexPath] == NO) {
            [cell setViewObject:[self viewObjectWithIndex:indexPath]];
        }
    }
    [[delegate tableView] setEditing:NO animated:NO];
}

- (UITableViewCell *)createAdditionalCell:(UITableView *)tableView {
    return [tableView dequeueReusableCellWithIdentifier:additionalCellId];;
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
        viewObjects = [viewObjects filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id e, id bindings) {
            return [e isEqual:viewObject] == NO;
        }]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
@end