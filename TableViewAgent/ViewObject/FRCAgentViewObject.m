//
// Created by P.I.akura on 2013/09/27.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "FRCAgentViewObject.h"
#import "TableViewAgent.h"

@interface FRCAgentViewObject () <NSFetchedResultsControllerDelegate>
@property (nonatomic) NSFetchedResultsController * controller;
@end

@implementation FRCAgentViewObject

- (id)initWithFetch:(NSFetchedResultsController *)controller {
    self = [super init];
    if (self) {
        self.controller = controller;
        self.controller.delegate = self;
    }
    return self;
}
- (void)dealloc {
    _controller = nil;
}
- (NSUInteger)sectionCount {
    if (_controller.sections.count == 1 && [_controller.sections[0] numberOfObjects] == 0) {
        return 0;
    }
    return _controller.sections.count;
}
- (NSUInteger)countInSection:(NSUInteger)section {
    return [_controller.sections[section] numberOfObjects];
}
- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    return [_controller objectAtIndexPath:indexPath];
}
- (DeleteViewObjectType)removeObjectAtIndexPath:(NSIndexPath *)indexPath {
    return DeleteViewObjectTypeNone;
}
- (BOOL)existObject:(NSIndexPath *)indexPath {
    return indexPath.section < [self sectionCount] && indexPath.row < [self countInSection:indexPath.section];
}
- (NSArray *)sectionObjects:(NSInteger)section {
    return @[[self objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]]];
}
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
        atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
        newIndexPath:(NSIndexPath *)newIndexPath {

    UITableView *tableView = self.agent.delegate.tableView;

    switch(type) {
        case NSFetchedResultsChangeInsert:
            if ([self sectionCount] != [tableView numberOfSections]) {
                [tableView insertSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            } else {
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                 withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            break;

        case NSFetchedResultsChangeDelete:
            if ([self sectionCount] != [tableView numberOfSections]) {
                [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            } else {
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                    withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            break;

        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;

        case NSFetchedResultsChangeMove:
            [tableView beginUpdates];
            switch ([@([self sectionCount]) compare:@([tableView numberOfSections])]) {
                case NSOrderedSame :
                    if ([self countInSection:newIndexPath.section] == 1) {
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
            break;
    }
}
@end