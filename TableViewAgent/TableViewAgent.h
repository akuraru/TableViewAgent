//
// Created by P.I.akura on 2013/06/15.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TableViewAgentCellDelegate.h"
#import "TableViewAgentProtocol.h"

@class AdditionalCellState;
@class EditableState;

typedef void override_void;
typedef id override_id;

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

@interface TableViewAgent : NSObject <UITableViewDataSource, UITableViewDelegate> {
    id<TableViewAgentDelegate> delegate;
    AdditionalCellState *addState;
    EditableState *editableState;
}

@property (strong, nonatomic) id<AgentViewObjectsDelegate> viewObjects;

- (void)setDelegate:(id<TableViewAgentDelegate>)delegate;

- (void)setAdditionalCellMode:(AdditionalCellMode)mode;
- (void)setEditableMode:(EditableMode)mode;

- (void)redraw;

- (void)insertRowWithSection:(NSInteger)section;
- (UITableViewCell *)dequeueCell:(NSIndexPath *)indexPath;

- (override_id)viewObjectWithIndex:(NSIndexPath *)indexPath;
- (override_void)setEditing:(BOOL)b;

@end