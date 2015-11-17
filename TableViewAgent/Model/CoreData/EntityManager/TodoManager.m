//
// Created by P.I.akura on 2013/09/27.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TodoManager.h"
#import "Todo.h"
#import <MagicalRecord/MagicalRecord.h>
#import "WETodo.h"

@implementation TodoManager

+ (NSFetchedResultsController *)fetchController {
    return [Todo MR_fetchAllGroupedBy:@"message" withPredicate:nil sortedBy:@"message,title" ascending:YES inContext:[self context]];
}

+ (void)deleteEntity:(id)object {
    [object MR_deleteEntityInContext:[self context]];
    [[self context] MR_saveToPersistentStoreAndWait];
}

+ (NSManagedObjectContext *)context {
    return [NSManagedObjectContext MR_defaultContext];
}

+ (void)updateEntity:(WETodo *)todo {
    Todo *entity = todo.todo ?: [Todo MR_createEntityInContext:[self context]];
    entity.title = todo.title;
    entity.message = todo.message;
    [[self context] MR_saveToPersistentStoreAndWait];
}
@end