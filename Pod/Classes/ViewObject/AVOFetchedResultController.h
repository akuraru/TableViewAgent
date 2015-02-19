//
// Created by P.I.akura on 2013/09/27.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <CoreData/NSFetchedResultsController.h>
#import "AgentViewObjectProtocol.h"
#import "AVOBase.h"

@class TableViewAgent;

@interface AVOFetchedResultController : AVOBase <AgentViewObjectProtocol>

@property(readonly, nonatomic) NSFetchedResultsController *controller;
@property(weak, nonatomic) id<TableViewAgentProtocol>agent;
@property(copy, nonatomic) id(^convert)(id);

- (id)initWithFetch:(NSFetchedResultsController *)controller;

@end
