//
// Created by P.I.akura on 2013/08/18.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "AgentViewObjectProtocol.h"
#import "AVOBase.h"

@interface AVOMultipleSections : AVOBase <AgentViewObjectProtocol>
@property(nonatomic, strong) NSMutableArray *array;
@property(weak, nonatomic) id<TableViewAgentProtocol>agent;
@property(copy, nonatomic) id(^convert)(id);

- (id)initWithArray:(NSMutableArray *)array;

- (void)addObject:(id)object inSection:(NSInteger)section;

- (void)changeObject:(id)object;

- (void)removeObject:(id)viewObject;
@end