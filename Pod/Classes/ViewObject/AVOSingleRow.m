//
// Created by P.I.akura on 2013/08/18.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AVOSingleRow.h"
#import "TableViewAgentCategory.h"

@implementation AVOSingleRow

- (id)initWithViewObject:(id)viewObject {
    self = [super init];
    if (self) {
        self.viewObject = viewObject;
    }
    return self;
}

- (NSIndexPath *)indexPathForObject:(id)object {
    if ([self.viewObject isEqual:object]) {
        return [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return nil;
}

- (NSUInteger)countInSection:(NSUInteger)section {
    return 1;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    return self.convert ? self.convert(self.viewObject) : self.viewObject;
}

- (BOOL)existObject:(NSIndexPath *)indexPath {
    return indexPath.row == 0 && indexPath.section == 0;
}

- (NSArray *)sectionObjects:(NSInteger)section {
    return @[self.viewObject];
}

- (NSUInteger)sectionCount {
    return 1;
}
@end