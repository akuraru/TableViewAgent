//
// Created by P.I.akura on 2013/06/15.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ViewObject.h"


@implementation ViewObject {
}
- (id)initWithTitle:(NSString *)title message:(NSString *)message {
    self = [super init];
    if (self) {
        self.title = title;
        self.message = message;
    }
    return self;
}

@end