//
//  AddOptionShowEditingViewController.h
//  TableViewAgent
//
//  Created by P.I.akura on 2013/06/18.
//  Copyright (c) 2013年 P.I.akura. All rights reserved.
//

#import "AdditionalCellState.h"

@class AddAndEditableTableViewAgent;

@interface AddOptionShowEditingViewController : UITableViewController

- (IBAction)touchEdit:(id)sender;
- (void)setAgent:(AddAndEditableTableViewAgent *)agent;

@end
