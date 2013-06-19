//
// Created by P.I.akura on 2013/06/15.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "EditableTableViewAgent.h"

@implementation EditableTableViewAgent {
}
- (void)setEditing:(BOOL)b {
    [[delegate tableView] setEditing:b animated:YES];
}

- (BOOL)editing {
    return [[delegate tableView] isEditing];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
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