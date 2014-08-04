//
//  Enum.h
//  TableViewAgent
//
//  Created by akuraru on 2014/07/31.
//  Copyright (c) 2014年 P.I.akura. All rights reserved.
//
#import <Foundation/Foundation.h>

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