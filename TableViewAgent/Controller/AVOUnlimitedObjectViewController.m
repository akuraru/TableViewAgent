//
//  AVOUnlimitedObjectViewController.m
//  TableViewAgent
//
//  Created by akuraru on 2015/11/29.
//  Copyright © 2015年 P.I.akura. All rights reserved.
//

#import "AVOUnlimitedObjectViewController.h"
#import "TableViewAgent.h"
#import "AVOUnlimitedObjectWorks.h"
#import "ViewObject.h"


@interface AVOUnlimitedObjectViewController ()
@property(nonatomic) TableViewAgent *agent;
@property(nonatomic) AVOUnlimitedObjectWorks *agentViewObject;
@end


@implementation AVOUnlimitedObjectViewController
- (IBAction)touchEdit:(id)sender {
    [self.agent setEditing:!self.agent.editing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"SectionView" bundle:nil];
    [self.tableView registerNib:nib forHeaderFooterViewReuseIdentifier:@"SectionView"];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    self.agent = [[TableViewAgent alloc] init];
    self.agentViewObject = [[AVOUnlimitedObjectWorks alloc] init];
    [self.agentViewObject setLoadObject:^(id source, AVOUnlimited limited) {
        return [[AVOUnlimitedLoadObject alloc] initWithLoad:@[
            [[ViewObject alloc] initWithTitle:@"hoge" message:@"2012/12/11"],
            [[ViewObject alloc] initWithTitle:@"piyo" message:@"2012/05/31"],
        ] source:nil];
    }];
    [self.agentViewObject setCellIdentifier:^NSString *(id o) {
        return @"CustomTableViewCell";
    }];
    self.agent.viewObjects = self.agentViewObject;
    self.agent.tableView = self.tableView;
    self.agentViewObject.initializeSourceData = nil;
}

- (void)onRefresh:(id)sender {
    [self.agentViewObject loadSuccessor];
    [self.refreshControl endRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.agent deselectRows];
}
@end
