//
// Created by P.I.akura on 2013/08/18.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SSAgentViewObject.h"
#import "TableViewAgentProtocol.h"

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
    [self.agent insertCell:self atIndexPath:[NSIndexPath indexPathForItem:_array.count - 1 inSection:0]];
}

- (void)changeObject:(id)object {
    NSIndexPath *path = [self indexPathForObject:object];
    if (path) {
        [self.agent changeUpdateCell:self atIndexPath:path];
    }
}

- (void)removeObjectAtIndexPath:(NSIndexPath *)indexPath {
    [_array removeObjectAtIndex:indexPath.row];
    [self.agent deleteCell:self atIndexPath:indexPath];
}

- (NSIndexPath *)indexPathForObject:(id)object {
    for (NSInteger i = 0, _len = _array.count; i < _len; i++) {
        if ([_array[i] isEqual:object]) {
            return [NSIndexPath indexPathForItem:i inSection:0];
        }
    }
    return nil;
}

- (void)dealloc {
    _array = nil;
}

- (NSUInteger)countInSection:(NSUInteger)section {
    return _array.count;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    id object = _array[indexPath.row];
    return self.convert ? self.convert(object) : object;
}

- (NSArray *)sectionObjects:(NSInteger)section {
    return _array;
}

- (NSUInteger)sectionCount {
    return 0 < _array.count;
}

- (void)setEditing:(BOOL)editing {
}
@end