//
// Created by P.I.akura on 2013/08/18.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "AgentViewObjectProtocol.h"

@interface AVOBase : NSObject
@property(copy, nonatomic) NSString *(^cellIdentifier)(id viewObject);
@property(copy, nonatomic) void (^didSelectCell)(id viewObject);
@property(copy, nonatomic) NSString *(^headerTitleForSectionObject)(id sectionObject);
@property(copy, nonatomic) NSString *(^footerTitleForSectionObject)(id sectionObject);
@property(copy, nonatomic) NSString *(^headerIdentifierForSectionObject)(id sectionObject);
@property(copy, nonatomic) void (^editingDeleteViewObject)(id viewObject);
@property(copy, nonatomic) void (^editingInsertViewObject)(id viewObject);

- (BOOL)canEditRowForIndexPath:(NSIndexPath *)indexPath;
- (BOOL)canEdit;
- (void)setEditableMode:(EditableMode)editableMode;
- (UITableViewCellEditingStyle)editingStyleForRowAtIndexPath:(NSIndexPath *)path;
- (NSString *)cellIdentifierAtIndexPath:(NSIndexPath *)indexPath;
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)titleForHeaderInSection:(NSInteger)section;
- (NSString *)titleForFooterInSection:(NSInteger)section;
- (NSString *)headerIdentifierInSection:(NSInteger)section;
- (void)editingDeleteForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)editingInsertForRowAtIndexPath:(NSIndexPath *)indexPath;

// need override
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (id)sectionObjectInSection:(NSInteger)section;
@end