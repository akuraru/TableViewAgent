//
// Created by P.I.akura on 2013/06/16.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class AddCellTableViewAgent;

@interface AddCellViewController : UITableViewController

- (IBAction)touchAdd:(id)sender;
- (void)setAgent:(AddCellTableViewAgent *)agent;

@end