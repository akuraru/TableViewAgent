//
// Created by P.I.akura on 2013/08/18.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AVOMergeSections.h"
#import "TableViewAgentCategory.h"

struct AVOMergeSectionPath {
    NSUInteger agentIndex;
    NSUInteger section;
};
typedef struct AVOMergeSectionPath AVOMergeSectionPath;

@implementation AVOMergeSections

- (id)initWithAgentViewObjects:(NSArray *)agentViewObjects {
    self = [super init];
    if (self) {
        self.agentViewObjects = agentViewObjects;
    }
    return self;
}

- (NSUInteger)countInSection:(NSUInteger)section {
    AVOMergeSectionPath path = [self sectionPathForIndexPath:section];
    return [self.agentViewObjects[path.agentIndex] countInSection:path.section];
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    AVOMergeSectionPath path = [self sectionPathForIndexPath:indexPath.section];
    id<AgentViewObjectProtocol> agentViewObject = self.agentViewObjects[path.agentIndex];
    id viewObject = [agentViewObject objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:path.section]];
    return self.convert ? self.convert(viewObject) : viewObject;
}

- (BOOL)existObject:(NSIndexPath *)indexPath {
    AVOMergeSectionPath path = [self sectionPathForIndexPath:indexPath.section];
    id<AgentViewObjectProtocol> agentViewObject = self.agentViewObjects[path.agentIndex];
    return [agentViewObject existObject:[NSIndexPath indexPathForRow:indexPath.row inSection:path.section]];
}

- (NSArray *)sectionObjects:(NSInteger)section {
    AVOMergeSectionPath path = [self sectionPathForIndexPath:section];
    id<AgentViewObjectProtocol> agentViewObject = self.agentViewObjects[path.agentIndex];
    return [agentViewObject sectionObjects:path.section];
}

- (NSUInteger)sectionCount {
    NSUInteger result = 0;
    for (id<AgentViewObjectProtocol> agentViewObject in self.agentViewObjects) {
        result += [agentViewObject sectionCount];
    }
    return result;
}

- (void)removeObjectAtIndexPath:(NSIndexPath *)indexPath {
}

- (AVOMergeSectionPath)sectionPathForIndexPath:(NSInteger)section {
    for (NSUInteger i = 0, _len = self.agentViewObjects.count; i < _len; i++) {
        id <AgentViewObjectProtocol> agentViewObject = self.agentViewObjects[i];
        if (section < [agentViewObject sectionCount]) {
            return (AVOMergeSectionPath){.agentIndex = i, .section = section};
        } else {
            section -= [agentViewObject sectionCount];
        }
    }
    NSAssert(false, @"can not map AVOMergeSectionPath");
    return (AVOMergeSectionPath){};
}
@end