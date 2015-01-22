//
// Created by P.I.akura on 2013/08/18.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "MSAgentViewObject.h"
#import "TableViewAgentCategory.h"

#ifdef DEBUG
#define precondition(code) ({code});
#else
#define precondition(code) ;
#endif

@implementation MSAgentViewObject

- (id)initWithArray:(NSMutableArray *)array {
    precondition(
            assert(![_array isKindOfClass:NSMutableArray.class]);
            for (int i = 0, _len = _array.count; i < _len; i++) {
                assert(![_array[i] isKindOfClass:NSMutableArray.class]);
            });

    self = [super init];
    if (self) {
        _array = array;
    }
    return self;
}

- (void)addObject:(id)object inSection:(NSInteger)section {
    if (_array.count == 0) {
        [_array addObject:[NSMutableArray array]];
    }
    [_array[section] addObject:object];
    [_agent insertCell:[NSIndexPath indexPathForItem:[_array[section] count] - 1 inSection:section]];
}

- (void)changeObject:(id)object {
    [_agent changeUpdateCell:[self indexPathForObject:object]];
}

- (NSIndexPath *)indexPathForObject:(id)object {
    for (NSInteger i = 0, _len = _array.count; i < _len; i++) {
        for (NSInteger j = 0, _len = [_array[i] count]; j < _len; j++) {
            if ([_array[i][j] isEqual:object]) {
                return [NSIndexPath indexPathForItem:j inSection:i];
            }
        }
    }
    return nil;
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
    id object = _array[indexPath.section][indexPath.row];
    return self.convert ? self.convert(object) : object;
}

- (void)removeObjectAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *a = _array[indexPath.section];
    [a removeObjectAtIndex:indexPath.row];
    if (a.count == 0) {
        [_array removeObjectAtIndex:indexPath.section];
    }
    [_agent deleteCell:indexPath];
}

- (BOOL)existObject:(NSIndexPath *)indexPath {
    return indexPath.section < _array.count && indexPath.row < [_array[indexPath.section] count];
}

- (NSArray *)sectionObjects:(NSInteger)section {
    return _array[section];
}

@end