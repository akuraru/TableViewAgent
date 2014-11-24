#import "Kiwi.h"
#import "AppDelegate.h"
#import "SSViewController.h"
#import "MainEntry.h"

SPEC_BEGIN(ShowTableView)
    describe(@"spec", ^{
        it (@"hoge", ^{
           AppDelegate *app = [[UIApplication sharedApplication] delegate];
            SSViewController *viewController = [[[MainEntry alloc] init] ss];

            NSDate *startDate = [NSDate date];
            __block NSDate *endDate;
            [app.window.rootViewController presentViewController:viewController animated:NO completion:^{
                endDate = [NSDate date];
            }];
            [[expectFutureValue(endDate) shouldEventually] beBetween:startDate and:[startDate dateByAddingTimeInterval:1]];
        });

    });
SPEC_END