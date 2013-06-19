//
// Created by P.I.akura on 2013/06/15.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "MainViewController.h"
#import "TableViewAgent.h"
#import "ExtactedID.h"
#import "SecondViewController.h"
#import "ViewObject.h"
#import "EditableViewController.h"
#import "MainService.h"

@implementation MainViewController {
    MainService *service;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    service = [MainService new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:[service segue:indexPath.row] sender:[self tableViewAgent:indexPath.row]];
}

- (TableViewAgent *)tableViewAgent:(NSInteger)index {
    TableViewAgent *agent = [service agentInstance:index];
    [agent setCellId:kReuseCell];
    [agent setViewObjects:@[
     [[ViewObject alloc] initWithTitle:@"hoge" message:@"2012/12/11"],
     [[ViewObject alloc] initWithTitle:@"piyo" message:@"2012/05/31"],
     [[ViewObject alloc] initWithTitle:@"fugafuga" message:@"2012/04/03"],
     ]];
    return agent;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([service existSegues:segue.identifier]) {
        [segue.destinationViewController setAgent:sender];
    }
}

@end