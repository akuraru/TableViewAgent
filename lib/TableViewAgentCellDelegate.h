//
// Created by P.I.akura on 2013/06/15.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@protocol TableViewAgentCellDelegate <NSObject>
- (void)setViewObject:(id)o;
@optional
- (void)setViewObject:(id)o common:(id)c;
- (CGFloat)heightFromViewObject:(id)o;
@end