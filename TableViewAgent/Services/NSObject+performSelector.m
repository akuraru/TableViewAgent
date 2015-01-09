#import "NSObject+performSelector.h"

@implementation NSObject (performSelector)

- (void)call:(NSString *)sel {
    [self performSelector:NSSelectorFromString(sel)];
}

- (id)get:(NSString *)sel {
    return [self performSelector:NSSelectorFromString(sel)];
}

- (void)call:(NSString *)sel withObject:(id)obj1 {
    [self performSelector:NSSelectorFromString(sel) withObject:obj1];
}

- (id)get:(NSString *)sel withObject:(id)obj1 {
    return [self performSelector:NSSelectorFromString(sel) withObject:obj1];
}

- (void)call:(NSString *)sel withObject:(id)obj1 withObject:(id)obj2 {
    [self performSelector:NSSelectorFromString(sel) withObject:obj1 withObject:obj2];
}

- (id)get:(NSString *)sel withObject:(id)obj1 withObject:(id)obj2 {
    return [self performSelector:NSSelectorFromString(sel) withObject:obj1 withObject:obj2];
}

@end