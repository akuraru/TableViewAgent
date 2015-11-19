//
// Created by akuraru on 2014/03/25.
// Copyright (c) 2014 P.I.akura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AgentViewObjectProtocol.h"
#import "AVOBase.h"

@interface AVOUnlimitedObjectWorks<__covariant ObjectType> : AVOBase <AgentViewObjectProtocol>
@property(readonly, nonatomic, strong) NSMutableArray<NSArray<ObjectType> *> *array;
@property(weak, nonatomic) id<TableViewAgentProtocol>agent;
@property(copy, nonatomic) id(^convert)(ObjectType objectType);
@property(nonatomic, strong) id initializeSourceData;

- (id)init;
@end
