//
// Created by akuraru on 2014/03/25.
// Copyright (c) 2014 P.I.akura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AgentViewObjectProtocol.h"
#import "AVOBase.h"

typedef NS_ENUM(NSInteger, AVOUnlimited) {
    AVOUnlimitedSuccessor,
    AVOUnlimitedPredecessor,
};

@interface AVOUnlimitedObjectWorks<__covariant ObjectType, SourceType> : AVOBase <AgentViewObjectProtocol>
@property(readonly, nonatomic, strong) NSMutableArray<NSArray<ObjectType> *> *array;
@property(weak, nonatomic) id<TableViewAgentProtocol>agent;
@property(copy, nonatomic) id(^convert)(ObjectType objectType);
@property(nonatomic, strong) SourceType initializeSourceData;

@property(copy, nonatomic) NSInteger(^countOfNextLoad)(SourceType source, AVOUnlimited type);
@property(copy, nonatomic) NSArray<ObjectType> *(^loadObject)(SourceType source);

- (id)init;

- (void)reload;
- (void)loadSuccessor;
- (void)loadPredecessor;
@end
