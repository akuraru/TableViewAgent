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
#import "AVOAdditionalSection.h"

@interface MSViewController () <TableViewAgentDelegate>
@property(nonatomic) TableViewAgent *agent;
@property(nonatomic) MSAgentViewObject *agentViewObject;
@end

@implementation MSViewController {

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
    self.agent.delegate = self;
}

- (MSAgentViewObject *)createAgentViewObject {
    MSAgentViewObject *agentViewObject = [[MSAgentViewObject alloc] initWithArray:@[@[
            [[ViewObject alloc] initWithTitle:@"hoge" message:@"2012/12/11"],
            [[ViewObject alloc] initWithTitle:@"piyo" message:@"2012/05/31"],
    ].mutableCopy, @[
            [[ViewObject alloc] initWithTitle:@"fugafuga" message:@"2012/04/03"],
    ].mutableCopy].mutableCopy];
    [agentViewObject setEditableMode:EditableModeEnable];
    [agentViewObject setCellIdentifier:^NSString *(id viewObject) {
        return kReuseCustomTableViewCell;
    }];
    [agentViewObject setDidSelectCell:^(id viewObject) {
        [self performSegueWithIdentifier:kSegueEdit sender:[[ThirdViewObject alloc] initWithViewObject:viewObject]];
    }];
    return agentViewObject;
}

- (AVOAdditionalSection *)createAdditionalSection {
    AVOAdditionalSection *additionalSection = [[AVOAdditionalSection alloc] initWithViewObject:kReuseAdd];
    [additionalSection setAdditionalCellMode:AdditionalCellModeShowEditing];
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

        [self.agentViewObject addObject:vo inSection:0];
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
