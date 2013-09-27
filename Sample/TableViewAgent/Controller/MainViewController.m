//
// Created by P.I.akura on 2013/06/15.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "MainViewController.h"
#import "TableViewAgent.h"
#import "ExtactedID.h"
#import "ViewObject.h"
#import "SSViewController.h"
#import "MainService.h"
#import "MagicalRecord.h"
#import "MagicalRecord+Setup.h"

@implementation MainViewController {
    MainService *service;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [MagicalRecord setupCoreDataStack];

    service = [MainService new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:[service segue:indexPath.row] sender:nil];
}
@end