//
// Created by P.I.akura on 2013/06/18.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "SingleSectionTableViewAgent.h"

typedef NS_ENUM (NSInteger, AdditionalCellMode) {
    AdditionalCellModeNone,
    AdditionalCellModeHideEdting,
    AdditionalCellModeShowEdting,
};

@interface AddAndEditableTableViewAgent : SingleSectionTableViewAgent
- (void)setAdditionalCellId:(NSString *)aci;
- (void)setAdditionalCellMode:(AdditionalCellMode)mode;

- (void)setEditing:(BOOL)b;

- (BOOL)editing;

- (void)addViewObject:(id)object;
@end