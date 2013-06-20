//
//  SSViewController.h
//  TableViewAgent
//
//  Created by P.I.akura on 2013/06/19.
//  Copyright (c) 2013年 P.I.akura. All rights reserved.
//

#import "AdditionalCellState.h"

@class SSTableViewAgent;

@interface SSViewController : UITableViewController

- (IBAction)touchEdit:(id)sender;
- (void)setAgent:(SSTableViewAgent *)agent;

@end
