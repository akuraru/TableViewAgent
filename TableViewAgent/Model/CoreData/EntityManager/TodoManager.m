//
// Created by P.I.akura on 2013/09/27.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TodoManager.h"
#import "Todo.h"
#import "CoreData+MagicalRecord.h"
#import "WETodo.h"

@implementation TodoManager

+ (NSFetchedResultsController *)fetchController {
    return [Todo MR_fetchAllGroupedBy:@"message" withPredicate:nil sortedBy:@"message,title" ascending:YES];
}

+ (void)deleteEntity:(NSManagedObject *)object {
    [object MR_deleteEntity];
    [object.managedObjectContext MR_saveToPersistentStoreAndWait];
}

+ (void)updateEntity:(WETodo *)todo {
    Todo *entity = todo.todo ?: [Todo MR_createEntity];
    [todo update:entity];
    [entity.managedObjectContext MR_saveToPersistentStoreAndWait];
}
@end