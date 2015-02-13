//
//  MSViewController.m
//  TableViewAgent
//
//  Created by P.I.akura on 2013/08/18.
//  Copyright (c) 2013年 P.I.akura. All rights reserved.
//

#import <TableViewAgent/AVOMergeSections.h>
#import "MSViewController.h"
#import "TableViewAgent.h"
#import "ExtactedID.h"
#import "ThirdViewObject.h"
#import "ViewObject.h"
#import "MSAgentViewObject.h"
#import "ThirdViewController.h"
#import "TableViewAgentDelegate.h"
#import "AVOAdditionalSection.h"

@interface MSViewController () <TableViewAgentDelegate>

@end

@implementation MSViewController {
    TableViewAgent *agent;
    MSAgentViewObject *agentViewObject;
}

- (IBAction)touchEdit:(id)sender {
    [agent setEditing:!agent.editing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    agent = [[TableViewAgent alloc] init];
    AVOAdditionalSection *additionalSection = [[AVOAdditionalSection alloc] initWithViewObject:kReuseAdd];
    [additionalSection setAdditionalCellMode:AdditionalCellModeShowEditing];
    [additionalSection setCellIdentifier:^NSString *(id viewObject) {
        return kReuseAdd;
    }];
    
    agentViewObject = [[MSAgentViewObject alloc] initWithArray:@[@[
            [[ViewObject alloc] initWithTitle:@"hoge" message:@"2012/12/11"],
            [[ViewObject alloc] initWithTitle:@"piyo" message:@"2012/05/31"],
    ].mutableCopy, @[
            [[ViewObject alloc] initWithTitle:@"fugafuga" message:@"2012/04/03"],
    ].mutableCopy].mutableCopy];
    [agentViewObject setEditableMode:EditableModeEnable];
    [agentViewObject setCellIdentifier:^NSString *(id viewObject) {
        return kReuseCustomTableViewCell;
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

        [agentViewObject addObject:vo inSection:0];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
}

- (UIView *)sectionHeader:(id)viewObject {
    if ([viewObject[0] isKindOfClass:[NSString class]]) {
        return nil;
    } else {
        return ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
            [label setText:[viewObject[0] message]];
            [label setBackgroundColor:[UIColor lightGrayColor]];
            label;
        });
    }
}
@end
