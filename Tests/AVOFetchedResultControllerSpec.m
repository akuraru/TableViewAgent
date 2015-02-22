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
        let(controller, ^{return [Todo MR_fetchAllGroupedBy:nil withPredicate:nil sortedBy:@"message,title" ascending:YES];});
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
    });
SPEC_END