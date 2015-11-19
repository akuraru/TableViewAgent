//
// Created by akuraru on 2014/03/25.
// Copyright (c) 2014 P.I.akura. All rights reserved.
//

#import "AVOUnlimitedObjectWorks.h"
#import "TableViewAgentProtocol.h"


@interface AVOUnlimitedObjectWorks ()
@end

@implementation AVOUnlimitedObjectWorks

- (id)init {
    self = [super init];
    if (self) {
        _array = [NSMutableArray array];
    }
    return self;
}

- (void)setInitializeSourceData:(id)initializeSourceData {
    _initializeSourceData = initializeSourceData;
    [self reload];
}

- (void)reload {
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

- (id)sectionObjectInSection:(NSInteger)section {
    return _array[section];
}

- (void)setEditing:(BOOL)editing {
}
@end
