//
//  SSViewController.h
//  TableViewAgent
//
//  Created by P.I.akura on 2013/06/19.
//  Copyright (c) 2013年 P.I.akura. All rights reserved.
//

#import "AdditionalCellState.h"

@interface SSViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIView *headerView;

- (IBAction)touchEdit:(id)sender;

@end
