#import <Kiwi/Kiwi.h>

SPEC_BEGIN(Tests)
context(@"tests", ^{
    it(@"t", ^{
        [[@(1) should] equal:@(1)];
    });
});
SPEC_END