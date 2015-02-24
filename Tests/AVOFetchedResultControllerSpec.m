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
        beforeEach(^{
            controller = [Todo MR_fetchAllGroupedBy:nil withPredicate:nil sortedBy:@"message,title" ascending:YES inContext:context];
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
        it(@"do delegate TableViewAgent controller:didChangeObject:atIndexPath:forChangeType:newIndexPath:" , ^{
            id mock = [KWMock mock];
            [[mock should] receive:@selector(controller:didChangeObject:atIndexPath:forChangeType:newIndexPath:)];
            controller.delegate = mock;
            [firstObject.managedObjectContext MR_saveOnlySelfAndWait];
            [[[Todo MR_findAllInContext:context][0] should] equal:firstObject];
        });
        it(@"do delegate TableViewAgent controller:didChangeSection:atIndex:forChangeType:", ^{
            id mock = [KWMock mock];
            controller.delegate = mock;
            [[mock should] receive:@selector(controller:didChangeSection:atIndex:forChangeType:)];
            [firstObject.managedObjectContext MR_saveToPersistentStoreAndWait];
            [[[Todo MR_findAllInContext:context][0] should] equal:firstObject];
        });
        it(@"do delegate TableViewAgent controllerWillChangeContent:", ^{
            id mock = [KWMock mock];
            controller.delegate = mock;
            [[mock should] receive:@selector(controllerWillChangeContent:)];
            [firstObject.managedObjectContext MR_saveToPersistentStoreAndWait];
            [[[Todo MR_findAllInContext:context][0] should] equal:firstObject];
        });
        it(@"do delegate TableViewAgent controllerDidChangeContent:", ^{
            id mock = [KWMock mock];
            controller.delegate = mock;
            [[mock should] receive:@selector(controllerDidChangeContent:)];
            [firstObject.managedObjectContext MR_saveToPersistentStoreAndWait];
            [[[Todo MR_findAllInContext:context][0] should] equal:firstObject];
        });
        it(@"do delegate TableViewAgent controller:sectionIndexTitleForSectionName:", ^{
            id mock = [KWMock mock];
            controller.delegate = mock;
            [[mock should] receive:@selector(controller:sectionIndexTitleForSectionName:)];
            [firstObject.managedObjectContext MR_saveToPersistentStoreAndWait];
            [[[Todo MR_findAllInContext:context][0] should] equal:firstObject];
        });
    });
    });
    });
SPEC_END
