//
// Created by P.I.akura on 2013/08/18.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AVOMergeSections.h"
#import "TableViewAgentProtocol.h"

struct AVOMergeSectionPath {
    NSUInteger agentIndex;
    NSUInteger section;
};
typedef struct AVOMergeSectionPath AVOMergeSectionPath;

@interface AVOMergeSections () <TableViewAgentProtocol>
@end

@implementation AVOMergeSections

- (id)initWithAgentViewObjects:(NSArray *)agentViewObjects {
    self = [super init];
    if (self) {
        self.agentViewObjects = agentViewObjects;
    }
    return self;
}

- (void)setAgent:(id <TableViewAgentProtocol>)agent {
    _agent = agent;
    for (id <AgentViewObjectProtocol> agentViewObject in self.agentViewObjects) {
        [agentViewObject setAgent:self];
    }
}

- (NSUInteger)countInSection:(NSUInteger)section {
    AVOMergeSectionPath path = [self sectionPathForIndexPath:section];
    return [self.agentViewObjects[path.agentIndex] countInSection:path.section];
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    AVOMergeSectionPath path = [self sectionPathForIndexPath:indexPath.section];
    id <AgentViewObjectProtocol> agentViewObject = self.agentViewObjects[path.agentIndex];
    return [agentViewObject objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:path.section]];
}

- (id)sectionObjectInSection:(NSInteger)section {
    AVOMergeSectionPath path = [self sectionPathForIndexPath:section];
    id <AgentViewObjectProtocol> agentViewObject = self.agentViewObjects[path.agentIndex];
    return [agentViewObject sectionObjectInSection:path.section];
}

- (NSUInteger)sectionCount {
    NSUInteger result = 0;
    for (id <AgentViewObjectProtocol> agentViewObject in self.agentViewObjects) {
        result += [agentViewObject sectionCount];
    }
    return result;
}

- (AVOMergeSectionPath)sectionPathForIndexPath:(NSInteger)section {
    for (NSUInteger i = 0, _len = self.agentViewObjects.count; i < _len; i++) {
        id <AgentViewObjectProtocol> agentViewObject = self.agentViewObjects[i];
        if (section < [agentViewObject sectionCount]) {
            return (AVOMergeSectionPath) {.agentIndex = i, .section = section};
        } else {
            section -= [agentViewObject sectionCount];
        }
    }
    NSAssert(false, @"can not map AVOMergeSectionPath");
    return (AVOMergeSectionPath) {};
}

- (BOOL)canEdit {
    for (id <AgentViewObjectProtocol> agentViewObject in self.agentViewObjects) {
        if ([agentViewObject canEdit]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)canEditRowForIndexPath:(NSIndexPath *)indexPath {
    AVOMergeSectionPath path = [self sectionPathForIndexPath:indexPath.section];
    id <AgentViewObjectProtocol> agentViewObject = self.agentViewObjects[path.agentIndex];
    return [agentViewObject canEditRowForIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:path.section]];
}

- (void)setEditing:(BOOL)editing {
    for (id <AgentViewObjectProtocol> agentViewObject in self.agentViewObjects) {
        [agentViewObject setEditing:editing];
    }
}

- (UITableViewCellEditingStyle)editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    AVOMergeSectionPath path = [self sectionPathForIndexPath:indexPath.section];
    id <AgentViewObjectProtocol> agentViewObject = self.agentViewObjects[path.agentIndex];
    return [agentViewObject editingStyleForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:path.section]];
}

- (NSString *)cellIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    AVOMergeSectionPath path = [self sectionPathForIndexPath:indexPath.section];
    id <AgentViewObjectProtocol> agentViewObject = self.agentViewObjects[path.agentIndex];
    return [agentViewObject cellIdentifierAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:path.section]];
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AVOMergeSectionPath path = [self sectionPathForIndexPath:indexPath.section];
    id <AgentViewObjectProtocol> agentViewObject = self.agentViewObjects[path.agentIndex];
    return [agentViewObject didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:path.section]];
}

- (NSString *)titleForHeaderInSection:(NSInteger)section {
    AVOMergeSectionPath path = [self sectionPathForIndexPath:section];
    id <AgentViewObjectProtocol> agentViewObject = self.agentViewObjects[path.agentIndex];
    return [agentViewObject titleForHeaderInSection:path.section];
}

- (NSString *)titleForFooterInSection:(NSInteger)section {
    AVOMergeSectionPath path = [self sectionPathForIndexPath:section];
    id <AgentViewObjectProtocol> agentViewObject = self.agentViewObjects[path.agentIndex];
    return [agentViewObject titleForFooterInSection:path.section];
}

- (NSString *)headerIdentifierInSection:(NSInteger)section {
    AVOMergeSectionPath path = [self sectionPathForIndexPath:section];
    id <AgentViewObjectProtocol> agentViewObject = self.agentViewObjects[path.agentIndex];
    return [agentViewObject headerIdentifierInSection:path.section];
}

- (void)editingDeleteForRowAtIndexPath:(NSIndexPath *)indexPath {
    AVOMergeSectionPath path = [self sectionPathForIndexPath:indexPath.section];
    id <AgentViewObjectProtocol> agentViewObject = self.agentViewObjects[path.agentIndex];
    return [agentViewObject editingDeleteForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:path.section]];
}

- (void)editingInsertForRowAtIndexPath:(NSIndexPath *)indexPath {
    AVOMergeSectionPath path = [self sectionPathForIndexPath:indexPath.section];
    id <AgentViewObjectProtocol> agentViewObject = self.agentViewObjects[path.agentIndex];
    return [agentViewObject editingInsertForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:path.section]];
}

#pragma mark - Table View Agent Protocol

- (void)deleteCell:(id <AgentViewObjectProtocol>)agentViewObject atIndexPath:(NSIndexPath *)indexPath {
    NSInteger startSection = [self startSectionForAgentViewObject:agentViewObject];
    [self.agent deleteCell:self atIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section + startSection]];
}

- (void)deleteSection:(id <AgentViewObjectProtocol>)agentViewObject atSection:(NSInteger)section {
    NSInteger startSection = [self startSectionForAgentViewObject:agentViewObject];
    [self.agent deleteSection:self atSection:section + startSection];
}

- (void)deleteCells:(id <AgentViewObjectProtocol>)agentViewObject atSection:(NSInteger)section rows:(NSArray *)rows {
    NSInteger startSection = [self startSectionForAgentViewObject:agentViewObject];
    [self.agent deleteCells:self atSection:section + startSection rows:rows];
}

- (void)insertCell:(id <AgentViewObjectProtocol>)agentViewObject atIndexPath:(NSIndexPath *)indexPath {
    NSInteger startSection = [self startSectionForAgentViewObject:agentViewObject];
    [self.agent insertCell:self atIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section + startSection]];
}

- (void)insertSection:(id <AgentViewObjectProtocol>)agentViewObject atSection:(NSInteger)section {
    NSInteger startSection = [self startSectionForAgentViewObject:agentViewObject];
    [self.agent insertSection:self atSection:section + startSection];
}

- (void)insertCells:(id <AgentViewObjectProtocol>)agentViewObject atSection:(NSInteger)section rows:(NSArray *)rows {
    NSInteger startSection = [self startSectionForAgentViewObject:agentViewObject];
    [self.agent insertCells:self atSection:section + startSection rows:rows];
}

- (void)changeUpdateCell:(id <AgentViewObjectProtocol>)agentViewObject atIndexPath:(NSIndexPath *)indexPath {
    NSInteger startSection = [self startSectionForAgentViewObject:agentViewObject];
    [self.agent changeUpdateCell:self atIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section + startSection]];
}

- (void)changeMoveCell:(id <AgentViewObjectProtocol>)agentViewObject fromIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath {
    NSInteger startSection = [self startSectionForAgentViewObject:agentViewObject];
    [self.agent changeMoveCell:self fromIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section + startSection] toIndexPath:[NSIndexPath indexPathForRow:newIndexPath.row inSection:newIndexPath.section + startSection]];
}

- (NSInteger)startSectionForAgentViewObject:(id <AgentViewObjectProtocol>)agentViewObject {
    NSInteger section = 0;
    for (id <AgentViewObjectProtocol> viewObject in self.agentViewObjects) {
        if ([viewObject isEqual:agentViewObject]) {
            break;
        } else {
            section += [viewObject sectionCount];
        }
    }
    return section;
}
@end
