//
// Created by P.I.akura on 2013/06/15.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TableViewAgentCellDelegate.h"


@protocol didSelectCell <NSObject>
- (void)didSelectCell:(id)viewObject;
@end
@protocol deleteCell <NSObject>
- (void)deleteCell:(id)viewObject;
@end
@protocol didSelectAdditionalCell
- (void)didSelectAdditionalCell;
@end
id viewObjects;
id delegate;

@interface TableViewAgent : NSObject <UITableViewDataSource, UITableViewDelegate> {
    NSString *cellId;
}

- (void)setCellId:(NSString *)cellId;
- (void)setViewObjects:(id)viewObjects;

- (void)setDelegate:(id)delegate;

- (id)viewObjectWithIndex:(NSIndexPath *)path;

- (void)redraw;

- (void)insertRowWithSection:(NSInteger)section;
@end