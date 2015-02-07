//
// Created by P.I.akura on 2013/06/15.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface ViewObject : NSObject <NSCopying>

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *message;

- (id)initWithTitle:(NSString *)title message:(NSString *)message;
@end