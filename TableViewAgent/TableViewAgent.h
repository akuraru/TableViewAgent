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
@optional
- (void)didSelectCell:(id)viewObject;
@end
@protocol deleteCell <NSObject>
@optional
- (void)deleteCell:(id)viewObject;
@end
@protocol didSelectAdditionalCell <NSObject>
@optional
- (void)didSelectAdditionalCell;
@end
@protocol cellIdentifier <NSObject>
- (NSString *)cellIdentifier:(id)viewObject;
@end

@protocol TableViewAgentDelegate <didSelectCell, deleteCell, didSelectAdditionalCell, cellIdentifier>
@end

typedef NS_ENUM (NSInteger, AdditionalCellMode) {
    AdditionalCellModeNone,
    AdditionalCellModeAlways,
    AdditionalCellModeHideEditing,
    AdditionalCellModeShowEditing,
    AdditionalCellModeHideEdting __attribute__((deprecated)),
    AdditionalCellModeShowEdting __attribute__((deprecated)),
};
typedef NS_ENUM (NSInteger, EditableMode) {
    EditableModeNone,
    EditableModeEnable,
};

@interface TableViewAgent : NSObject <UITableViewDataSource, UITableViewDelegate> {
    id delegate;
    AdditionalCellState *addState;
    EditableState *editableState;
}

@property (strong, nonatomic) id viewObjects;

- (void)setDelegate:(id)delegate;

- (void)setAdditionalCellMode:(AdditionalCellMode)mode;
- (void)setEditableMode:(EditableMode)mode;

- (void)redraw;

- (void)insertRowWithSection:(NSInteger)section;
- (UITableViewCell *)dequeueCell:(NSIndexPath *)indexPath;

- (override_id)viewObjectWithIndex:(NSIndexPath *)indexPath;
- (override_void)setEditing:(BOOL)b;

@end