//
// Created by P.I.akura on 2013/06/16.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AddCellTableViewAgent.h"
#import "ViewObject.h"


@implementation AddCellTableViewAgent {
}

- (void)addViewObject:(id)object {
    viewObjects = [viewObjects arrayByAddingObject:object];
    [self insertRowWithSection:0];
}
@end