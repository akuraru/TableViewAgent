//
// Created by P.I.akura on 2013/06/16.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class ViewObject;


@interface ThirdViewObject : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *message;
@property (nonatomic, readonly) ViewObject *viewObject;

- (id)initWithViewObject:(ViewObject *)viewObject;

@end