//
// Created by P.I.akura on 2013/08/18.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@protocol TableViewAgentProtocol;
@protocol TableViewAgentSectionViewDelegate;

typedef NS_ENUM (NSInteger, EditableMode) {
    EditableModeNone,
    EditableModeEnable,
    EditableModeEditingEnable,
    EditableModeEditingNonEnable,
};

@protocol AgentViewObjectProtocol <NSObject>
- (NSUInteger)sectionCount;
- (NSUInteger)countInSection:(NSUInteger)section;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (id)sectionObjectInSection:(NSInteger)section;
@property(weak, nonatomic) id<TableViewAgentProtocol>agent;

// editing
- (BOOL)canEditRowForIndexPath:(NSIndexPath *)indexPath;
- (BOOL)canEdit;
- (void)setEditing:(BOOL)editing;

- (UITableViewCellEditingStyle)editingStyleForRowAtIndexPath:(NSIndexPath *)path;

- (NSString *)cellIdentifierAtIndexPath:(NSIndexPath *)indexPath;
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)titleForHeaderInSection:(NSInteger)section;
- (NSString *)headerIdentifierInSection:(NSInteger)section;

- (void)editingDeleteForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)editingInsertForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
@property(copy, nonatomic) id(^convert)(id);

// editing
- (void)setEditableMode:(EditableMode)editableMode;

//
@property(copy, nonatomic) NSString *(^cellIdentifier)(id viewObject);
@property(copy, nonatomic) void (^didSelectCell)(id viewObject);
@property(copy, nonatomic) NSString *(^headerTitleForSectionObject)(id sectionObject);
@property(copy, nonatomic) NSString *(^headerIdentifierForSectionObject)(id sectionObject);

@property(copy, nonatomic) void (^editingDeleteViewObject)(id viewObject);
@property(copy, nonatomic) void (^editingInsertViewObject)(id viewObject);
@end
