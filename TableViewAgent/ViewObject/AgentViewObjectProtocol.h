//
// Created by P.I.akura on 2013/08/18.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@protocol sectionCount <NSObject>
@optional
- (NSUInteger)sectionCount;
@end
@protocol countInSection <NSObject>
- (NSUInteger)countInSection:(NSUInteger)section;
@end
@protocol objectAtIndexPath <NSObject>
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
@end
@protocol addObject <NSObject>
- (void)addObject:(id)object;
@end
@protocol removeObjectAtIndexPath <NSObject>
- (void)removeObjectAtIndexPath:(NSIndexPath *)indexPath;
@end
@protocol existObject <NSObject>
- (BOOL)existObject:(NSIndexPath *)indexPath;
@end
@protocol indexPathAddCell <NSObject>
@optional
- (NSIndexPath *)indexPathAddCell;
@end

@protocol AgentViewObjectProtocol <sectionCount, countInSection, objectAtIndexPath, addObject, removeObjectAtIndexPath, existObject, indexPathAddCell>
@end