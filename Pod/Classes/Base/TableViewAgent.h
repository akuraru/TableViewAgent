//
// Created by P.I.akura on 2013/06/15.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TableViewAgentCellDelegate.h"
#import "TableViewAgentDelegate.h"

@class EditableState;
@protocol AgentViewObjectProtocol;

@interface TableViewAgent : NSObject

@property (nonatomic) id<AgentViewObjectProtocol> viewObjects;
@property (weak, nonatomic) id<TableViewAgentDelegate> delegate;
@property (nonatomic) BOOL editing;

- (void)redraw;
@end