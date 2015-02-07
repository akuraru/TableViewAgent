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
#import "ThirdViewController.h"

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
    agent.viewObjects = [[FRCAgentViewObject alloc] initWithFetch:[TodoManager fetchController]];
    agent.delegate = self;
    [agent setEditableMode:EditableModeEnable];
    [agent setAdditionalCellMode:AdditionalCellModeAlways];
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
    return kReuseCustomTableViewCell;
}

- (void)didSelectCell:(ViewObject *)viewObject {
    [self performSegueWithIdentifier:kSegueEdit sender:[[WETodo alloc] initWithTodo:viewObject]];
}
- (void)deleteCell:(id)viewObject {
    [TodoManager deleteEntity:viewObject];
}
- (NSString *)sectionTitle:(NSArray *)viewObjects {
    return [viewObjects[0] title];
}

- (NSString *)addCellIdentifier {
    return kReuseAdd;
}
- (void)didSelectAdditionalCell {
    [self performSegueWithIdentifier:kSegueEdit sender:[[WETodo alloc] initWithTodo:nil]];
}
@end