//
// Created by P.I.akura on 2013/08/18.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class TableViewAgent;

@protocol sectionCount <NSObject>
- (NSUInteger)sectionCount;
@end
@protocol countInSection <NSObject>
- (NSUInteger)countInSection:(NSUInteger)section;
@end
@protocol objectAtIndexPath <NSObject>
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
@end
@protocol removeObjectAtIndexPath <NSObject>
- (void)removeObjectAtIndexPath:(NSIndexPath *)indexPath;
@end
@protocol existObject <NSObject>
- (BOOL)existObject:(NSIndexPath *)indexPath;
@end
@protocol sectionObjects <NSObject>
- (NSArray *)sectionObjects:(NSInteger)section;
@end
@protocol agent <NSObject>
@property (weak, nonatomic) TableViewAgent *agent;
@end

@protocol AgentViewObjectProtocol <sectionCount, countInSection, objectAtIndexPath, removeObjectAtIndexPath, existObject, sectionObjects, agent>
@end