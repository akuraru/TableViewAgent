#import <Foundation/Foundation.h>

@interface NSObject (performSelector)
- (void)call:(NSString *)sel;

- (id)get:(NSString *)sel;

- (void)call:(NSString *)sel withObject:(id)obj1;

- (id)get:(NSString *)sel withObject:(id)obj1;

- (void)call:(NSString *)sel withObject:(id)obj1 withObject:(id)obj2;

- (id)get:(NSString *)sel withObject:(id)obj1 withObject:(id)obj2;
@end