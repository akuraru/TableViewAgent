//
// Created by P.I.akura on 2013/09/27.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WETodo;

@interface TodoManager : NSObject

+ (NSFetchedResultsController *)fetchController;

+ (void)deleteEntity:(id)object;

+ (void)updateEntity:(WETodo *)todo;
@end