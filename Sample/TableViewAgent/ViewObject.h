//
// Created by P.I.akura on 2013/06/15.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface ViewObject : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *date;

- (id)initWithTitle:(NSString *)title date:(NSString *)date;
@end