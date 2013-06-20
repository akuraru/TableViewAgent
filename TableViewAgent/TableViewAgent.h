//
// Created by P.I.akura on 2013/06/15.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TableViewAgentCellDelegate.h"

@class AdditionalCellState;
@class EditableState;

typedef void override_void;
typedef id override_id;

@protocol didSelectCell <NSObject>
- (void)didSelectCell:(id)viewObject;
@end
@protocol deleteCell <NSObject>
- (void)deleteCell:(id)viewObject;
@end
@protocol didSelectAdditionalCell <NSObject>
- (void)didSelectAdditionalCell;
@end

@protocol TableViewAgentDelegate <didSelectCell, deleteCell, didSelectAdditionalCell>
@end

typedef NS_ENUM (NSInteger, AdditionalCellMode) {
    AdditionalCellModeNone,
    AdditionalCellModeAlways,
    AdditionalCellModeHideEdting,
    AdditionalCellModeShowEdting,
};
typedef NS_ENUM (NSInteger, EditableMode) {
    EditableModeNone,
    EditableModeEnable,
};

@interface TableViewAgent : NSObject <UITableViewDataSource, UITableViewDelegate> {
    NSString *cellId;
    id viewObjects;
    id delegate;
    AdditionalCellState *addState;
    EditableState *editableState;
}

- (void)setCellId:(NSString *)cellId;
- (void)setViewObjects:(id)viewObjects;
- (void)setDelegate:(id)delegate;

- (void)setAdditionalCellMode:(AdditionalCellMode)mode;
- (void)setEditableMode:(EditableMode)mode;

- (void)redraw;

- (void)insertRowWithSection:(NSInteger)section;

- (override_id)viewObjectWithIndex:(NSIndexPath *)indexPath;
- (override_void)setEditing:(BOOL)b;

@end