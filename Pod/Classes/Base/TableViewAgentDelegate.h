//
// Created by P.I.akura on 2013/06/21.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@protocol TableViewAgentDelegate <NSObject>
- (NSString *)cellIdentifier:(id)viewObject;

@optional
- (void)didSelectCell:(id)viewObject;
- (void)deleteCell:(id)viewObject;
- (void)didSelectAdditionalCell;
@end
