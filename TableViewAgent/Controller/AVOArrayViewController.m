//
//  AVOArrayViewController.m
//  TableViewAgent
//
//  Created by akuraru on 2015/02/07.
//  Copyright (c) 2015年 P.I.akura. All rights reserved.
//

#import "TableViewAgent.h"
#import "AVOArrayControoler.h"
#import "ViewObject.h"
#import "AVOFetchedResultController.h"
#import "ThirdViewController.h"
#import "ThirdViewObject.h"
#import "ExtactedID.h"
#import "AVOAdditionalSection.h"

@interface AVOArrayViewController : UITableViewController
@property(nonatomic) TableViewAgent *agent;
@property(nonatomic) AVOArrayController *arrayController;
@end

@implementation AVOArrayViewController {
}

- (IBAction)touchEdit:(id)sender {
    [self.agent setEditing:!self.agent.editing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.agent = [[TableViewAgent alloc] init];
    self.arrayController = [self createArrayController];
    self.agent.viewObjects = [self createAgentViewObject:self.arrayController];
    self.agent.tableView = self.tableView;
    [self.agent.viewObjects setEditableMode:EditableModeEnable];
}

- (AVOArrayController *)createArrayController {
    NSArray *viewObjects = @[
        [[ViewObject alloc] initWithTitle:@"hoge" message:@"A"],
        [[ViewObject alloc] initWithTitle:@"piyo" message:@"B"],
        [[ViewObject alloc] initWithTitle:@"fugafuga" message:@"A"],
    ];
    return [[AVOArrayController alloc] initWithArray:viewObjects groupedBy:@"message" withPredicate:nil sortedBy:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 message] compare:[obj2 message]];
    }];
}

- (AVOFetchedResultController *)createAgentViewObject:(id)arrayController {
    AVOFetchedResultController *agentViewObject = [[AVOFetchedResultController alloc] initWithFetch:arrayController];
    [agentViewObject setCellIdentifier:^NSString *(id viewObject) {
        return kReuseCustomTableViewCell;
    }];
    [agentViewObject setDidSelectCell:^(id viewObject) {
        [self performSegueWithIdentifier:kSegueEdit sender:[[ThirdViewObject alloc] initWithViewObject:viewObject]];
    }];
    [agentViewObject setEditingDeleteViewObject:^(id viewObject) {
        [self.arrayController removeObject:viewObject];
    }];
    return agentViewObject;
}

- (AVOAdditionalSection *)createAdditionalSection {
    AVOAdditionalSection *additionalSection = [[AVOAdditionalSection alloc] initWithViewObject:kReuseAdd];
    [additionalSection setAdditionalCellMode:AdditionalCellModeAlways];
    [additionalSection setCellIdentifier:^NSString *(id viewObject) {
        return kReuseAdd;
    }];
    __weak typeof(self) this = self;
    [additionalSection setDidSelectCell:^(id viewObject) {
        [this performSegueWithIdentifier:kSegueEdit sender:[[ThirdViewObject alloc] initWithViewObject:nil]];
    }];
    [additionalSection setEditingInsertViewObject:^(id viewObject) {
        [this performSegueWithIdentifier:kSegueEdit sender:[[ThirdViewObject alloc] initWithViewObject:nil]];
    }];
    return additionalSection;
}

- (void)saveViewObject:(ThirdViewObject *)tvo {
    if (tvo.viewObject) {
        ViewObject *vo = tvo.viewObject;
        vo.title = tvo.title;
        vo.message = tvo.message;

        [self.arrayController updateObject:vo];
    } else {
        ViewObject *vo = [[ViewObject alloc] init];
        vo.title = tvo.title;
        vo.message = tvo.message;

        [self.arrayController addObject:vo];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.agent redraw];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kSegueEdit]) {
        ThirdViewController *controller = segue.destinationViewController;
        [controller setViewObject:sender];
        [controller setDelegate:self];
    }
}
@end
