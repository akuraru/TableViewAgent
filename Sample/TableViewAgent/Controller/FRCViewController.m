//
// Created by P.I.akura on 2013/09/27.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "FRCViewController.h"
#import "TableViewAgent.h"
#import "ExtactedID.h"
#import "ThirdViewObject.h"
#import "ViewObject.h"
#import "MSAgentViewObject.h"
#import "FRCAgentViewObject.h"
#import "TodoManager.h"
#import "WETodo.h"

@interface FRCViewController () <TableViewAgentDelegate>
@end

@implementation FRCViewController {
    TableViewAgent *agent;
}
- (IBAction)touchNew:(id)sender {
    [self performSegueWithIdentifier:kSegueEdit sender:[[WETodo alloc] init]];
}

- (IBAction)touchEdit:(id)sender {
    [agent setEditing:!agent.editing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setToolbarHidden:NO animated:NO];

    agent = [[TableViewAgent alloc] init];
    FRCAgentViewObject *object = [[FRCAgentViewObject alloc] initWithFetch:[TodoManager fetchController]];
    object.agent = agent;
    agent.viewObjects = object;
    agent.delegate = self;
    [agent setEditableMode:EditableModeEnable];
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
        [segue.destinationViewController setViewObject:sender];
        [segue.destinationViewController setDelegate:self];
    }
}

#pragma -
#pragma mark TableViewAgentDelegate
- (NSString *)cellIdentifier:(id)viewObject {
    return @"Cell";
}

- (void)didSelectCell:(ViewObject *)viewObject {
    [self performSegueWithIdentifier:kSegueEdit sender:[[WETodo alloc] initWithTodo:viewObject]];
}
- (void)deleteCell:(id)viewObject {
    [TodoManager deleteEntity:viewObject];
}
- (void)didSelectAdditionalCell {
    [self performSegueWithIdentifier:kSegueEdit sender:[[WETodo alloc] initWithTodo:nil]];
}
- (NSString *)sectionTitle:(NSArray *)viewObjects {
    return [viewObjects[0] title];
}
@end