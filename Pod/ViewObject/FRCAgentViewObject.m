//
// Created by P.I.akura on 2013/09/27.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "FRCAgentViewObject.h"
#import "TableViewAgentCategory.h"

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
- (void)removeObjectAtIndexPath:(NSIndexPath *)indexPath {
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
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [_agent insertCell:newIndexPath];
            break;

        case NSFetchedResultsChangeDelete:
            [_agent deleteCell:indexPath];
            break;

        case NSFetchedResultsChangeUpdate:
            [_agent changeUpdateCell:indexPath];
            break;

        case NSFetchedResultsChangeMove:
            [_agent changeMoveCell:indexPath toIndexPath:newIndexPath];
            break;
    }
}
@end