//
//  SSViewController.m
//  TableViewAgent
//
//  Created by P.I.akura on 2013/06/19.
//  Copyright (c) 2013年 P.I.akura. All rights reserved.
//

#import <TableViewAgent/AVOMergeSections.h>
#import "SSViewController.h"
#import "TableViewAgent.h"
#import "ExtactedID.h"
#import "ThirdViewObject.h"
#import "ViewObject.h"
#import "SSAgentViewObject.h"
#import "ThirdViewController.h"
#import "AVOAdditionalSection.h"

@interface SSViewController ()
@property(nonatomic) TableViewAgent *agent;
@property(nonatomic) SSAgentViewObject *agentViewObject;
@end

@implementation SSViewController {
}

- (IBAction)touchEdit:(id)sender {
    [self.agent setEditing:!self.agent.editing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.agent = [[TableViewAgent alloc] init];
    self.agentViewObject = [self createAgentViewObject];
    self.agent.viewObjects = [[AVOMergeSections alloc] initWithAgentViewObjects:@[
            self.agentViewObject,
            [self createAdditionalSection],
    ]];
    self.agent.tableView = self.tableView;
}

- (SSAgentViewObject *)createAgentViewObject {
    SSAgentViewObject *agentViewObject = [[SSAgentViewObject alloc] initWithArray:@[
            [[ViewObject alloc] initWithTitle:@"hoge" message:@"2012/12/11"],
            [[ViewObject alloc] initWithTitle:@"piyo" message:@"2012/05/31"],
            [[ViewObject alloc] initWithTitle:@"fugafuga" message:@"2012/04/03"],
    ]];
    [agentViewObject setEditableMode:EditableModeEnable];
    [agentViewObject setCellIdentifier:^NSString *(id viewObject) {
        return kReuseCustomTableViewCell;
    }];
    [agentViewObject setDidSelectCell:^(id viewObject) {
        [self performSegueWithIdentifier:kSegueEdit sender:[[ThirdViewObject alloc] initWithViewObject:viewObject]];
    }];
    __weak typeof(agentViewObject) avo = agentViewObject;
    [agentViewObject setEditingDeleteViewObject:^(id viewObject) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.agentViewObject.array indexOfObject:viewObject] inSection:0];
        [avo removeObjectAtIndexPath:indexPath];
    }];
    return agentViewObject;
}

- (AVOAdditionalSection *)createAdditionalSection {
    AVOAdditionalSection *additionalSection = [[AVOAdditionalSection alloc] initWithViewObject:kReuseAdd];
    [additionalSection setAdditionalCellMode:AdditionalCellModeHideEditing];
    [additionalSection setCellIdentifier:^NSString *(id viewObject) {
        return kReuseAdd;
    }];
    [additionalSection setDidSelectCell:^(id viewObject) {
        [self performSegueWithIdentifier:kSegueEdit sender:[[ThirdViewObject alloc] initWithViewObject:nil]];
    }];
    return additionalSection;
}

- (void)saveViewObject:(ThirdViewObject *)tvo {
    if (tvo.viewObject) {
        ViewObject *vo = tvo.viewObject;
        vo.title = tvo.title;
        vo.message = tvo.message;

        [self.agentViewObject changeObject:vo];
    } else {
        ViewObject *vo = [[ViewObject alloc] init];
        vo.title = tvo.title;
        vo.message = tvo.message;

        [self.agentViewObject addObject:vo];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kSegueEdit]) {
        ThirdViewController *controller = segue.destinationViewController;
        [controller setViewObject:sender];
        [controller setDelegate:self];
    }
}
@end
