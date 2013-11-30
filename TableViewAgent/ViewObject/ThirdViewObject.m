//
// Created by P.I.akura on 2013/06/16.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ThirdViewObject.h"
#import "ViewObject.h"


@implementation ThirdViewObject {
}

- (id)initWithViewObject:(ViewObject *)vo {
    self = [super init];
    if (self) {
        _viewObject = vo;
        self.title = (vo.title) ? : @"";
        self.message = (vo.message) ? : @"";
    }
    return self;
}

@end