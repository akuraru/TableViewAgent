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
#import "FRCAgentViewObject.h"
#import "TodoManager.h"
#import "WETodo.h"
#import "ThirdViewController.h"
#import "TableViewAgentDelegate.h"
#import "AVOAdditionalSection.h"

@interface FRCViewController () <TableViewAgentDelegate>
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
    self.agent.delegate = self;
}

- (FRCAgentViewObject *)createAgentViewObject {
    FRCAgentViewObject *agentViewObject = [[FRCAgentViewObject alloc] initWithFetch:[TodoManager fetchController]];
    [agentViewObject setEditableMode:EditableModeEnable];
    [agentViewObject setCellIdentifier:^NSString *(id viewObject) {
        return kReuseCustomTableViewCell;
    }];
    [agentViewObject setDidSelectCell:^(id viewObject) {
        [self performSegueWithIdentifier:kSegueEdit sender:[[WETodo alloc] initWithTodo:viewObject]];
    }];
    return agentViewObject;
}

- (AVOAdditionalSection *)createAdditionalSection {
    AVOAdditionalSection *additionalSection = [[AVOAdditionalSection alloc] initWithViewObject:kReuseAdd];
    [additionalSection setAdditionalCellMode:AdditionalCellModeAlways];
    [additionalSection setCellIdentifier:^NSString *(id viewObject) {
        return kReuseAdd;
    }];
    [additionalSection setDidSelectCell:^(id viewObject) {
        [self performSegueWithIdentifier:kSegueEdit sender:[[WETodo alloc] initWithTodo:nil]];
    }];
    return additionalSection;
}

- (void)saveViewObject:(WETodo *)we {
    [TodoManager updateEntity:we];
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

#pragma -
#pragma mark TableViewAgentDelegate

- (void)deleteCell:(id)viewObject {
    [TodoManager deleteEntity:viewObject];
}

- (void)insertCell:(id)viewObject {
    [self performSegueWithIdentifier:kSegueEdit sender:[[WETodo alloc] initWithTodo:nil]];
}

- (NSString *)sectionTitle:(NSArray *)viewObjects {
    if ([viewObjects[0] isKindOfClass:[NSString class]]) {
        return nil;
    } else {
        return [viewObjects[0] title];
    }
}

@end
