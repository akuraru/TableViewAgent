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
    self.agentViewObject= [[SSAgentViewObject alloc] initWithArray:@[
     [[ViewObject alloc] initWithTitle:@"hoge" message:@"2012/12/11"],
     [[ViewObject alloc] initWithTitle:@"piyo" message:@"2012/05/31"],
     [[ViewObject alloc] initWithTitle:@"fugafuga" message:@"2012/04/03"],
     ]];
    [self.agentViewObject setEditableMode:EditableModeEnable];
    [self.agentViewObject setCellIdentifier:^NSString *(id viewObject) {
        return kReuseCustomTableViewCell;
    }];
    AVOAdditionalSection *additionalSection = [[AVOAdditionalSection alloc] initWithViewObject:kReuseAdd];
    [additionalSection setAdditionalCellMode:AdditionalCellModeHideEditing];
    [additionalSection setCellIdentifier:^NSString *(id viewObject) {
        return kReuseAdd;
    }];

    self.agent.viewObjects = [[AVOMergeSections alloc] initWithAgentViewObjects:@[
            self.agentViewObject,
            additionalSection,
    ]];
    self.agent.delegate = self;
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
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.agentViewObject.array indexOfObject:viewObject] inSection:0];
    [self.agentViewObject removeObjectAtIndexPath:indexPath];
}
@end
