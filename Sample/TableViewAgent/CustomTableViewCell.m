//
// Created by P.I.akura on 2013/06/15.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "CustomTableViewCell.h"
#import "ViewObject.h"


@implementation CustomTableViewCell {
}

- (void)setViewObject:(ViewObject *)o {
    self.textLabel.text = o.title;
    self.detailTextLabel.text = o.date;
}
@end