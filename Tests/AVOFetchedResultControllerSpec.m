#import <Kiwi/Kiwi.h>
#import "AVOFetchedResultController.h"
#import "Todo.h"
#import "CoreData+MagicalRecord.h"

SPEC_BEGIN(AVOFetchedResultControllerSpec)
    beforeEach(^{
        [MagicalRecord setDefaultModelFromClass:[self class]];
        [MagicalRecord setupCoreDataStackWithInMemoryStore];
    });
    afterEach(^{
        [MagicalRecord cleanUp];
    });
    describe(@"make context", ^{
        __block NSManagedObjectContext *context;
        beforeEach(^{
            context = [NSManagedObjectContext MR_defaultContext];
        });
    describe(@"meke empty controller", ^{
        __block NSFetchedResultsController *controller;
        __block AVOFetchedResultController *avo;
        __block id mock;
        beforeEach(^{
            mock = [KWMock mock];
            controller = [Todo MR_fetchAllSortedBy:@"message,title" ascending:YES withPredicate:nil groupBy:nil delegate:mock inContext:context];
            avo = [[AVOFetchedResultController alloc] initWithFetch:controller];
        });
        it(@"controller is empty sectionIndexTitles", ^{
            [[[controller sectionIndexTitles] should] equal:@[]];
        });
        it(@"controller is empty fetchedObjects", ^{
            [[[controller fetchedObjects] should] equal:@[]];
        });
        it(@"controller is empty sections", ^{
            [[theValue([[controller sections] count]) should] equal:theValue(1)];
            id section = [controller sections][0];
            [[[section name] should] beNil];
            [[[section indexTitle] should] beNil];
            [[theValue([section numberOfObjects]) should] equal:theValue(0)];
            [[[section objects] should] equal:@[]];
        });
    describe(@"make firstObject", ^{
        __block Todo *firstObject;
        beforeEach(^{
            firstObject = [Todo MR_createInContext:context];
            firstObject.title = @"title";
            firstObject.message = @"message";
        });
        it(@"do delegate NSFetchedResultsControllerDelegate controller:didChangeObject:atIndexPath:forChangeType:newIndexPath:" , ^{
            [[mock should] receive:@selector(controller:didChangeObject:atIndexPath:forChangeType:newIndexPath:)];
            [firstObject.managedObjectContext MR_saveOnlySelfAndWait];
            [[controller.fetchedObjects[0] should] equal:firstObject];
        });
        it(@"do delegate NSFetchedResultsControllerDelegate controller:didChangeSection:atIndex:forChangeType:", ^{
            [[mock should] receive:@selector(controller:didChangeSection:atIndex:forChangeType:)];
            [firstObject.managedObjectContext MR_saveToPersistentStoreAndWait];
            [[controller.fetchedObjects[0] should] equal:firstObject];
        });
        it(@"do delegate NSFetchedResultsControllerDelegate controllerWillChangeContent:", ^{
            [[mock should] receive:@selector(controllerWillChangeContent:)];
            [firstObject.managedObjectContext MR_saveToPersistentStoreAndWait];
            [[controller.fetchedObjects[0] should] equal:firstObject];
        });
        it(@"do delegate NSFetchedResultsControllerDelegate controllerDidChangeContent:", ^{
            [[mock should] receive:@selector(controllerDidChangeContent:)];
            [firstObject.managedObjectContext MR_saveToPersistentStoreAndWait];
            [[controller.fetchedObjects[0] should] equal:firstObject];
        });
        it(@"do delegate NSFetchedResultsControllerDelegate controller:sectionIndexTitleForSectionName:", ^{
            [[mock should] receive:@selector(controller:sectionIndexTitleForSectionName:)];
            [firstObject.managedObjectContext MR_saveToPersistentStoreAndWait];
            [[controller.fetchedObjects[0] should] equal:firstObject];
        });
    });
    });
    });
SPEC_END
