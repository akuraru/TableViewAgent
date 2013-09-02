//
// Created by P.I.akura on 2013/08/18.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SSAgentViewObject.h"


@implementation SSAgentViewObject

- (id)initWithArray:(NSArray *)array {
    self = [super init];
    if (self) {
        _array = array.mutableCopy;
    }
    return self;
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
- (BOOL)addObject:(id)object {
    [_array addObject:object];
    return 1 == _array.count;
}
- (BOOL)removeObjectAtIndexPath:(NSIndexPath *)indexPath {
    [_array removeObjectAtIndex:indexPath.row];
    return 0 == _array.count;
}
- (BOOL)existObject:(NSIndexPath *)indexPath {
    return indexPath.section == 0 && indexPath.row < _array.count;
}
- (NSIndexPath *)indexPathAddCell {
    return [NSIndexPath indexPathForRow:0 inSection:1];
}
- (NSArray *)sectionObjects:(NSInteger)section {
    return _array;
}
- (NSUInteger)sectionCount {
    return 0 < _array.count;
}
@end