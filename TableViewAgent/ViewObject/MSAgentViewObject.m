//
// Created by P.I.akura on 2013/08/18.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "MSAgentViewObject.h"

#ifdef DEBUG
#define precondition(code) ({code});
#else
#define precondition(code) ;
#endif

@implementation MSAgentViewObject

- (id)initWithArray:(NSMutableArray *)array {
    precondition(
    assert(![_array isKindOfClass:NSMutableArray.class]);
    for (int i = 0, _len = _array.count; i < _len ; i++ ) {
        assert(![_array[i] isKindOfClass:NSMutableArray.class]);
    });

    self = [super init];
    if (self) {
        _array = array;
    }
    return self;
}
- (void)dealloc {
    _array = nil;
}
- (NSUInteger)sectionCount {
    return _array.count;
}
- (NSUInteger)countInSection:(NSUInteger)section {
    return [_array[section] count];
}
- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    return _array[indexPath.section][indexPath.row];
}
- (void)addObject:(id)object {
    [_array[0] addObject:object];
}
- (void)removeObjectAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *a = _array[indexPath.section];
    [a removeObjectAtIndex:indexPath.row];
    if (a.count == 0) {
        [_array removeObjectAtIndex:indexPath.section];
    }
}
- (BOOL)existObject:(NSIndexPath *)indexPath {
    return indexPath.section < _array.count;
}
- (NSIndexPath *)indexPathAddCell {
    return [NSIndexPath indexPathForRow:0 inSection:_array.count];
}
@end