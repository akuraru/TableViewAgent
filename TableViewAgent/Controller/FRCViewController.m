//
// Created by P.I.akura on 2013/09/27.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <TableViewAgent/AVOMergeSections.h>
#import "FRCViewController.h"
#import "TableViewAgent.h"
#import "ExtactedID.h"
#import "ThirdViewObject.h"
#import "ViewObject.h"
#import "AVOFetchedResultController.h"
#import "TodoManager.h"
#import "WETodo.h"
#import "ThirdViewController.h"
#import "AVOAdditionalSection.h"
#import "FRCAgentViewObject.h"

@interface FRCViewController ()
@property (nonatomic) TableViewAgent *agent;
@end

@implementation FRCViewController {
}

- (IBAction)touchEdit:(id)sender {
    [self.agent setEditing:!self.agent.editing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.agent = [[TableViewAgent alloc] init];
    self.agent.viewObjects = [[AVOMergeSections alloc] initWithAgentViewObjects:@[
            [self createAgentViewObject],
            [self createAdditionalSection],
    ]];
    self.agent.tableView = self.tableView;
}

- (AVOFetchedResultController *)createAgentViewObject {
    AVOFetchedResultController *agentViewObject = [[AVOFetchedResultController alloc] initWithFetch:[TodoManager fetchController]];
    [agentViewObject setEditableMode:EditableModeEnable];
    [agentViewObject setCellIdentifier:^NSString *(id viewObject) {
        return kReuseCustomTableViewCell;
    }];
    [agentViewObject setDidSelectCell:^(id viewObject) {
        [self performSegueWithIdentifier:kSegueEdit sender:[[WETodo alloc] initWithTodo:viewObject]];
    }];
    [agentViewObject setHeaderTitleForSectionObject:^NSString *(id sectionObject) {
        return [sectionObject name];
    }];
    [agentViewObject setEditingDeleteViewObject:^(id viewObject) {
        [TodoManager deleteEntity:viewObject];
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
        [this performSegueWithIdentifier:kSegueEdit sender:[[WETodo alloc] initWithTodo:nil]];
    }];
    [additionalSection setEditingInsertViewObject:^(id viewObject) {
        [this performSegueWithIdentifier:kSegueEdit sender:[[WETodo alloc] initWithTodo:nil]];
    }];
    return additionalSection;
}

- (void)saveViewObject:(WETodo *)we {
    [TodoManager updateEntity:we];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kSegueEdit]) {
        ThirdViewController *controller = segue.destinationViewController;
        [controller setViewObject:sender];
        [controller setDelegate:self];
    }
}
@end
