//
// Created by P.I.akura on 2013/06/15.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TableViewAgentCellDelegate.h"
#import "TableViewAgentProtocol.h"

@class EditableState;
@protocol AgentViewObjectProtocol;

typedef NS_ENUM (NSInteger, AdditionalCellMode) {
    AdditionalCellModeNone,
    AdditionalCellModeAlways,
    AdditionalCellModeHideEditing,
    AdditionalCellModeShowEditing,
};
typedef NS_ENUM (NSInteger, EditableMode) {
    EditableModeNone,
    EditableModeEnable,
};

@interface TableViewAgent : NSObject

@property (nonatomic) id<AgentViewObjectProtocol> viewObjects;
@property (weak, nonatomic) id<TableViewAgentDelegate> delegate;
@property (nonatomic) BOOL editing;

- (void)setAdditionalCellMode:(AdditionalCellMode)mode;
- (void)setEditableMode:(EditableMode)mode;

- (void)redraw;

- (BOOL)compareSectionCount:(NSUInteger)count;
@end