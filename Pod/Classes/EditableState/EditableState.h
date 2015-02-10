//
//  EditableState.h
//  TableViewAgent
//
//  Created by P.I.akura on 2013/06/20.
//  Copyright (c) 2013年 P.I.akura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EditableState : NSObject

- (BOOL)canEdit;
- (BOOL)editableForEditing:(BOOL)editing;

@end
