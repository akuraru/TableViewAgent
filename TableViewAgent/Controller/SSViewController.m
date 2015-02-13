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

@interface SSViewController () <TableViewAgentDelegate>
@end

@implementation SSViewController {
    TableViewAgent *agent;
    SSAgentViewObject *agentViewObject;
}

- (IBAction)touchEdit:(id)sender {
    [agent setEditing:!agent.editing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    agent = [[TableViewAgent alloc] init];
    agentViewObject= [[SSAgentViewObject alloc] initWithArray:@[
     [[ViewObject alloc] initWithTitle:@"hoge" message:@"2012/12/11"],
     [[ViewObject alloc] initWithTitle:@"piyo" message:@"2012/05/31"],
     [[ViewObject alloc] initWithTitle:@"fugafuga" message:@"2012/04/03"],
     ]];
    [agentViewObject setEditableMode:EditableModeEnable];
    [agentViewObject setCellIdentifier:^NSString *(id viewObject) {
        return kReuseCustomTableViewCell;
    }];
    AVOAdditionalSection *additionalSection = [[AVOAdditionalSection alloc] initWithViewObject:kReuseAdd];
    [additionalSection setAdditionalCellMode:AdditionalCellModeHideEditing];
    [additionalSection setCellIdentifier:^NSString *(id viewObject) {
        return kReuseAdd;
    }];

    agent.viewObjects = [[AVOMergeSections alloc] initWithAgentViewObjects:@[
            agentViewObject,
            additionalSection,
    ]];
    agent.delegate = self;
}

- (void)saveViewObject:(ThirdViewObject *)tvo {
    if (tvo.viewObject) {
        ViewObject *vo = tvo.viewObject;
        vo.title = tvo.title;
        vo.message = tvo.message;
        
        [agentViewObject changeObject:vo];
    } else {
        ViewObject *vo = [[ViewObject alloc] init];
        vo.title = tvo.title;
        vo.message = tvo.message;
        
        [agentViewObject addObject:vo];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kSegueEdit]) {
        ThirdViewController *controller = segue.destinationViewController;
        [controller setViewObject:sender];
        [controller setDelegate:self];
    }
}

#pragma -
#pragma mark TableViewAgentDelegate

- (void)didSelectCell:(ViewObject *)viewObject {
    if ([viewObject isKindOfClass:[NSString class]]) {
        [self performSegueWithIdentifier:kSegueEdit sender:[[ThirdViewObject alloc] initWithViewObject:nil]];
    } else {
        [self performSegueWithIdentifier:kSegueEdit sender:[[ThirdViewObject alloc] initWithViewObject:viewObject]];
    }
}

- (void)deleteCell:(id)viewObject {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[agentViewObject.array indexOfObject:viewObject] inSection:0];
    [agentViewObject removeObjectAtIndexPath:indexPath];
}
@end
