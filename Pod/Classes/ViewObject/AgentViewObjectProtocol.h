//
// Created by P.I.akura on 2013/08/18.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class TableViewAgent;

@protocol AgentViewObjectProtocol <NSObject>
- (NSUInteger)sectionCount;
- (NSUInteger)countInSection:(NSUInteger)section;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (void)removeObjectAtIndexPath:(NSIndexPath *)indexPath __attribute__ ((deprecated));
- (BOOL)existObject:(NSIndexPath *)indexPath __attribute__ ((deprecated));
- (NSArray *)sectionObjects:(NSInteger)section;
@property (weak, nonatomic) TableViewAgent *agent;

@optional
@property(copy, nonatomic) id(^convert)(id);
@end