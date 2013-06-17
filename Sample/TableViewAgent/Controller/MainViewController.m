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
#import "SimpleTableViewAgent.h"
#import "ViewObject.h"
#import "SelectCellTableViewAgent.h"
#import "EditableViewController.h"
#import "EditableTableViewAgent.h"
#import "AddCellTableViewAgent.h"
#import "AdditionalCellTableViewAgent.h"

@implementation MainViewController {
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:[self segue:indexPath.row] sender:[self tableViewAgent:indexPath.row]];
}

- (NSString *)segue:(NSInteger)i {
    switch (i) {
        case 0 : return kSegueAgent;
        case 1 : return kSegueAgent;
        case 2 : return kSegueEditable;
        case 3 : return kSegueAdd;
        case 4 : return kSegueAdditionalCell;
    }
    return kSegueAgent;
}

- (TableViewAgent *)tableViewAgent:(NSInteger)index {
    TableViewAgent *agent = [self agentInstance:index];
    [agent setCellId:kReuseCell];
    [agent setViewObjects:@[
            [[ViewObject alloc] initWithTitle:@"hoge" message:@"2012/12/11"],
            [[ViewObject alloc] initWithTitle:@"piyo" message:@"2012/05/31"],
            [[ViewObject alloc] initWithTitle:@"fuga" message:@"2012/04/03"],
    ]];
    return agent;
}

- (TableViewAgent *)agentInstance:(NSInteger)i {
    switch (i) {
        case 0 : return [[SimpleTableViewAgent alloc] init];
        case 1 : return [[SelectCellTableViewAgent alloc] init];
        case 2 : return [[EditableTableViewAgent alloc] init];
        case 3 : return [[AddCellTableViewAgent alloc] init];
        case 4 : return [[AdditionalCellTableViewAgent alloc] init];
    }
    return [[SimpleTableViewAgent alloc] init];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([self knowSegues:segue.identifier]) {
        [segue.destinationViewController setAgent:sender];
    }
}

- (BOOL)knowSegues:(NSString *)string {
    for (NSString *segue in @[kSegueAgent, kSegueEditable, kSegueAdd, kSegueAdditionalCell]) {
        if ([segue isEqualToString:string]) {
            return YES;
        }
    }
    return NO;
}

@end