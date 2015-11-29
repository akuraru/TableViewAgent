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

@interface AVOUnlimitedLoadObject<__covariant ObjectType, SourceType>: NSObject
@property (strong, nonatomic) NSArray<ObjectType> *loadObject;
@property (strong, nonatomic) SourceType nextSourceObject;

- (instancetype)initWithLoad:(NSArray<ObjectType> *)loadObject source:(SourceType)nextObject;
@end

@interface AVOUnlimitedObjectWorks<__covariant ObjectType, SourceType> : AVOBase <AgentViewObjectProtocol>
@property(readonly, nonatomic, strong) NSMutableArray<NSArray<ObjectType> *> *array;
@property(weak, nonatomic) id<TableViewAgentProtocol>agent;
@property(copy, nonatomic) id(^convert)(ObjectType objectType);
@property(nonatomic, strong) SourceType initializeSourceData;

@property(copy, nonatomic) NSInteger(^countOfNextLoad)(SourceType source, AVOUnlimited type);
@property(copy, nonatomic) AVOUnlimitedLoadObject<ObjectType, SourceType> *(^loadObject)(SourceType source, AVOUnlimited type);

- (id)init;

- (void)reload;
- (void)loadSuccessor;
- (void)loadPredecessor;
@end
