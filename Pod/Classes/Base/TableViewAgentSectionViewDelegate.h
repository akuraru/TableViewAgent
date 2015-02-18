
#import <Foundation/Foundation.h>

@protocol TableViewAgentSectionViewDelegate <NSObject>
+ (CGFloat)heightFromSectionObject:(id)o;
- (void)setSectionObject:(id)o;
@end
