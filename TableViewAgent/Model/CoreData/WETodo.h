//
// Created by P.I.akura on 2013/09/27.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class Todo;

@interface WETodo : NSObject

@property (readonly, nonatomic) id todo;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *message;

- (id)initWithTodo:(id)todo;

- (void)update:(Todo *)todo;
@end