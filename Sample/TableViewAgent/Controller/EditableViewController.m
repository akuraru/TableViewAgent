//
// Created by P.I.akura on 2013/06/15.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "EditableViewController.h"
#import "TableViewAgentCellDelegate.h"
#import "ExtactedID.h"
#import "ViewObject.h"
#import "TableViewAgent.h"
#import "EditableTableViewAgent.h"

@implementation EditableViewController {
    EditableTableViewAgent *agent;
}

- (IBAction)touchEdit:(id)sender {
    [agent setEditing:!agent.editing];
}

- (void)setAgent:(id)a {
    agent = a;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    agent.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [agent redraw];
}

- (void)didSelectCell:(ViewObject *)viewObject {
    [self performSegueWithIdentifier:kSegueEdit sender:viewObject];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kSegueEdit]) {
        [segue.destinationViewController setViewObject:sender];
    }
}

- (void)deleteCell:(id)viewObject {
}

@end