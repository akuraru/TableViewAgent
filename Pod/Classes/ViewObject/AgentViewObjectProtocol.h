//
// Created by P.I.akura on 2013/08/18.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@protocol TableViewAgentProtocol;

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
- (NSArray *)sectionObjects:(NSInteger)section;
@property(weak, nonatomic) id<TableViewAgentProtocol>agent;

// editing
- (BOOL)canEditRowForIndexPath:(NSIndexPath *)indexPath;
- (BOOL)canEdit;
- (void)setEditing:(BOOL)editing;

@optional
@property(copy, nonatomic) id(^convert)(id);

// editing
- (void)setEditableMode:(EditableMode)editableMode;
@end
