//
//  AdditionalCellState.h
//  TableViewAgent
//
//  Created by P.I.akura on 2013/06/18.
//  Copyright (c) 2013年 P.I.akura. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, ChangeInState) {
    ChangeInStateNone,
    ChangeInStateHide,
    ChangeInStateShow,
};

@interface AdditionalCellState : NSObject

- (BOOL)isShowAddCell:(BOOL)edting;
- (ChangeInState)changeInState:(BOOL)edting;

@end
