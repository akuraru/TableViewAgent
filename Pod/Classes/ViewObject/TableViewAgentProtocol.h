//
//  TableViewAgentCategory.h
//  TableViewAgent
//
//  Created by P.I.akura on 2013/10/13.
//  Copyright (c) 2013年 P.I.akura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableViewAgent.h"

@protocol AgentViewObjectProtocol;

@protocol TableViewAgentProtocol

- (void)deleteCell:(id<AgentViewObjectProtocol>)agentViewObject atIndexPath:(NSIndexPath *)indexPath;
- (void)deleteSection:(id<AgentViewObjectProtocol>)agentViewObject atSection:(NSInteger)section;
- (void)deleteCells:(id<AgentViewObjectProtocol>)agentViewObject atSection:(NSInteger)section rows:(NSArray *)rows;
- (void)insertCell:(id<AgentViewObjectProtocol>)agentViewObject atIndexPath:(NSIndexPath *)indexPath;
- (void)insertSection:(id<AgentViewObjectProtocol>)agentViewObject atSection:(NSInteger)section;
- (void)insertCells:(id<AgentViewObjectProtocol>)agentViewObject atSection:(NSInteger)section rows:(NSArray *)rows;
- (void)changeUpdateCell:(id<AgentViewObjectProtocol>)agentViewObject atIndexPath:(NSIndexPath *)indexPath;
- (void)changeMoveCell:(id<AgentViewObjectProtocol>)agentViewObject fromIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath;

@end
