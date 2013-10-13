//
// Created by P.I.akura on 2013/08/18.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SSAgentViewObject.h"
#import "TableViewAgentCategory.h"

@implementation SSAgentViewObject

- (id)initWithArray:(NSArray *)array {
    self = [super init];
    if (self) {
        _array = array.mutableCopy;
    }
    return self;
}
- (void)addObject:(id)object {
    [_array addObject:object];
}
- (void)dealloc {
    _array = nil;
}
- (NSUInteger)countInSection:(NSUInteger)section {
    return _array.count;
}
- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    return _array[indexPath.row];
}
- (void)removeObjectAtIndexPath:(NSIndexPath *)indexPath {
    [_array removeObjectAtIndex:indexPath.row];
    [self.agent deleteCell:indexPath];
}
- (BOOL)existObject:(NSIndexPath *)indexPath {
    return indexPath.section == 0 && indexPath.row < _array.count;
}
- (NSArray *)sectionObjects:(NSInteger)section {
    return _array;
}
- (NSUInteger)sectionCount {
    return 0 < _array.count;
}
@end