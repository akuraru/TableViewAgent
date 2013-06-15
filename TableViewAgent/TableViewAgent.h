//
// Created by P.I.akura on 2013/06/15.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface TableViewAgent : NSObject <UITableViewDataSource, UITableViewDelegate> {
    NSString *cellId;
    id viewObjects;
    id delegate;
}

- (void)setCellId:(NSString *)cellId;
- (void)setViewObjects:(id)viewObjects;

- (void)setDelegate:(id)delegate;

- (id)viewObjectWithIndex:(NSIndexPath *)path;
@end