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

@implementation MainViewController {
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:kSegueAgent sender:[self tableViewAgent:indexPath.row]];
}

- (TableViewAgent *)tableViewAgent:(NSInteger)index {
    TableViewAgent *agent = [self agentInstance:index];
    [agent setCellId:kReuseCell];
    [agent setViewObjects:@[
            [[ViewObject alloc] initWithTitle:@"hoge" date:@"2012/12/11"],
            [[ViewObject alloc] initWithTitle:@"piyo" date:@"2012/05/31"],
            [[ViewObject alloc] initWithTitle:@"fuga" date:@"2012/04/03"],
    ]];
    return agent;
}

- (TableViewAgent *)agentInstance:(NSInteger)i {
    return [[SimpleTableViewAgent alloc] init];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kSegueAgent]) {
        [segue.destinationViewController setAgent:sender];
    }
}
@end