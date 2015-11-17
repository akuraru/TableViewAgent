//
// Created by P.I.akura on 2013/08/18.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "AgentViewObjectProtocol.h"
#import "AVOBase.h"

@protocol TableViewAgentProtocol;

typedef NS_ENUM (NSInteger, AdditionalCellMode) {
    AdditionalCellModeNone,
    AdditionalCellModeAlways,
    AdditionalCellModeHideEditing,
    AdditionalCellModeShowEditing,
};

@interface AVOAdditionalSection : NSObject <AgentViewObjectProtocol>
@property(strong, nonatomic) id viewObject;
@property(weak, nonatomic) id <TableViewAgentProtocol> agent;
@property(copy, nonatomic) id (^convert)(id);
@property(copy, nonatomic) NSString *(^cellIdentifier)(id viewObject);
@property(copy, nonatomic) void (^didSelectCell)(id viewObject);
@property(copy, nonatomic) UIColor *(^cellBackgroundColorForObject)(id viewObject);
@property(copy, nonatomic) UIColor *(^headerViewBackgroundColorForSectionObject)(id sectionObject);
@property(copy, nonatomic) UIColor *(^footerViewBackgroundColorForSectionObject)(id sectionObject);
@property(copy, nonatomic) NSString *(^headerTitleForSectionObject)(id sectionObject);
@property(copy, nonatomic) NSString *(^footerTitleForSectionObject)(id sectionObject);
@property(copy, nonatomic) NSString *(^headerIdentifierForSectionObject)(id sectionObject);
@property(copy, nonatomic) NSString *(^footerIdentifierForSectionObject)(id sectionObject);
@property(copy, nonatomic) void (^didSelectAccessoryButton)(id viewObject);
@property(copy, nonatomic) void (^editingInsertViewObject)(id viewObject);
@property(nonatomic) BOOL editing;

- (id)initWithViewObject:(id)viewObject;

- (void)setAdditionalCellMode:(AdditionalCellMode)mode;
@end