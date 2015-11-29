//
// Created by akuraru on 2014/03/25.
// Copyright (c) 2014 P.I.akura. All rights reserved.
//

#import "AVOUnlimitedObjectWorks.h"
#import "TableViewAgentProtocol.h"


@interface AVOUnlimitedObjectWorks<__covariant ObjectType, SourceType> ()
@property(nonatomic, strong) SourceType successorSourceData;
@property(nonatomic, strong) SourceType predecessorSourceData;
@end

@implementation AVOUnlimitedLoadObject
- (instancetype)initWithLoad:(NSArray *)loadObject source:(id)nextSourceObject {
    self = [super init];
    if (self) {
        self.loadObject = loadObject;
        self.nextSourceObject = nextSourceObject;
    }
    return self;
}
@end

@implementation AVOUnlimitedObjectWorks

- (id)init {
    self = [super init];
    if (self) {
        _array = [NSMutableArray array];
        self.countOfNextLoad = nil;
        self.loadObject = nil;
    }
    return self;
}

- (void)setInitializeSourceData:(id)initializeSourceData {
    _initializeSourceData = initializeSourceData;
    self.successorSourceData = initializeSourceData;
    self.predecessorSourceData = initializeSourceData;
    [self reload];
}

- (void)reload {
    NSInteger count = self.countOfNextLoad ? self.countOfNextLoad(self.initializeSourceData, AVOUnlimitedSuccessor) : 1;
    id nextObject = self.initializeSourceData;
    for (NSInteger i = 0; i < count; i++) {
        AVOUnlimitedLoadObject *loadObject = self.loadObject(nextObject, AVOUnlimitedSuccessor);
        [self.array addObject:loadObject.loadObject];
        nextObject = loadObject.nextSourceObject;
        [self.agent insertSection:self atSection:self.array.count - 1];
    }
    self.successorSourceData = nextObject;
}
- (void)loadSuccessor {
    NSInteger count = self.countOfNextLoad ? self.countOfNextLoad(self.successorSourceData, AVOUnlimitedSuccessor) : 1;
    id nextObject = self.successorSourceData;
    for (NSInteger i = 0; i < count; i++) {
        AVOUnlimitedLoadObject *loadObject = self.loadObject(nextObject, AVOUnlimitedSuccessor);
        [self.array addObject:loadObject.loadObject];
        nextObject = loadObject.nextSourceObject;
        [self.agent insertSection:self atSection:self.array.count - 1];
    }
    self.successorSourceData = nextObject;
}
- (void)loadPredecessor {
    NSInteger count = self.countOfNextLoad ? self.countOfNextLoad(self.predecessorSourceData, AVOUnlimitedPredecessor) : 1;
    id nextObject = self.predecessorSourceData;
    for (NSInteger i = 0; i < count; i++) {
        AVOUnlimitedLoadObject *loadObject = self.loadObject(nextObject, AVOUnlimitedPredecessor);
        [self.array insertObject:loadObject.loadObject atIndex:0];
        nextObject = loadObject.nextSourceObject;
        [self.agent insertSection:self atSection:0];
    }
    self.predecessorSourceData = nextObject;
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
