//
// Created by P.I.akura on 2013/06/18.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class AddAndEditableTableViewAgent;

@interface AddOptionNoneViewController : UITableViewController

- (IBAction)touchEdit:(id)sender;
- (void)setAgent:(AddAndEditableTableViewAgent *)agent;

@end