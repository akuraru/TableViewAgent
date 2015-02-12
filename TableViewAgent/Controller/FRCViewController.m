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
@end

@implementation FRCViewController {
    TableViewAgent *agent;
}

- (IBAction)touchEdit:(id)sender {
    [agent setEditing:!agent.editing];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    agent = [[TableViewAgent alloc] init];
    AVOAdditionalSection *additionalSection = [[AVOAdditionalSection alloc] initWithViewObject:kReuseAdd];
    [additionalSection setAdditionalCellMode:AdditionalCellModeAlways];
    FRCAgentViewObject *viewObject = [[FRCAgentViewObject alloc] initWithFetch:[TodoManager fetchController]];
    [viewObject setEditableMode:EditableModeEnable];
    agent.viewObjects = [[AVOMergeSections alloc] initWithAgentViewObjects:@[
            viewObject,
            additionalSection,
    ]];
    agent.delegate = self;
}

- (void)saveViewObject:(WETodo *)we {
    [TodoManager updateEntity:we];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [agent redraw];
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

- (NSString *)cellIdentifier:(id)viewObject {
    if ([viewObject isKindOfClass:[NSString class]]) {
        return kReuseAdd;
    } else {
        return kReuseCustomTableViewCell;
    }
}

- (void)didSelectCell:(ViewObject *)viewObject {
    if ([viewObject isKindOfClass:[NSString class]]) {
        [self performSegueWithIdentifier:kSegueEdit sender:[[WETodo alloc] initWithTodo:nil]];
    } else {
        [self performSegueWithIdentifier:kSegueEdit sender:[[WETodo alloc] initWithTodo:viewObject]];
    }
}

- (void)deleteCell:(id)viewObject {
    [TodoManager deleteEntity:viewObject];
}

- (NSString *)sectionTitle:(NSArray *)viewObjects {
    if ([viewObjects[0] isKindOfClass:[NSString class]]) {
        return nil;
    } else {
        return [viewObjects[0] title];
    }
}

- (void)didSelectAdditionalCell {
    [self performSegueWithIdentifier:kSegueEdit sender:[[WETodo alloc] initWithTodo:nil]];
}
@end