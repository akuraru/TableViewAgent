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

- (NSString *)cellIdentifierAtIndexPath:(NSIndexPath *)indexPath;
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)canEditRowForIndexPath:(NSIndexPath *)indexPath;
- (BOOL)canEdit;
- (void)setEditableMode:(EditableMode)editableMode;
- (UITableViewCellEditingStyle)editingStyleForRowAtIndexPath:(NSIndexPath *)path;

// need override
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
@end