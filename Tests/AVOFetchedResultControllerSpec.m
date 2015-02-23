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
    describe(@"meke empty controller", ^{
        let(controller, ^NSFetchedResultsController{return [Todo MR_fetchAllGroupedBy:nil withPredicate:nil sortedBy:@"message,title" ascending:YES];});
        let(avo, ^{return [[AVOFetchedResultController alloc] initWithFetch:controller];});
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
        let(firstObject, ^{
            Todo *todo = [Todo MR_createEntity];
            todo.title = @"title";
            todo.message = @"message";
            return todo;
        });
        it(@"do delegate TableViewAgent controller:didChangeObject:atIndexPath:forChangeType:newIndexPath:" , ^{});
        it(@"do delegate TableViewAgent controller:didChangeSection:atIndex:forChangeType:", ^{});
        it(@"do delegate TableViewAgent controllerWillChangeContent:", ^{});
        it(@"do delegate TableViewAgent controllerDidChangeContent:", ^{});
        it(@"do delegate TableViewAgent controller:sectionIndexTitleForSectionName:", ^{});
    });
SPEC_END
