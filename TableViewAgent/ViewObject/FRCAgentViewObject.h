//
// Created by P.I.akura on 2013/09/27.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <CoreData/NSFetchedResultsController.h>
#import "AgentViewObjectProtocol.h"

@class TableViewAgent;

@interface FRCAgentViewObject : NSObject <AgentViewObjectProtocol>

@property (readonly, nonatomic) NSFetchedResultsController * controller;
@property (weak, nonatomic) TableViewAgent *agent;

- (id)initWithFetch:(NSFetchedResultsController *)controller;

@end