//
//  AddOptionHideEditingViewController.h
//  TableViewAgent
//
//  Created by P.I.akura on 2013/06/18.
//  Copyright (c) 2013年 P.I.akura. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddAndEditableTableViewAgent;

@interface AddOptionHideEditingViewController : UITableViewController

- (IBAction)touchEdit:(id)sender;
- (void)setAgent:(AddAndEditableTableViewAgent *)agent;

@end
