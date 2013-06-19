//
//  AddOptionHideEditingViewController.m
//  TableViewAgent
//
//  Created by P.I.akura on 2013/06/18.
//  Copyright (c) 2013年 P.I.akura. All rights reserved.
//

#import "AddOptionHideEditingViewController.h"
#import "TableViewAgentCellDelegate.h"
#import "ExtactedID.h"
#import "ViewObject.h"
#import "AddAndEditableTableViewAgent.h"
#import "ThirdViewObject.h"
#import "AddAndEditableTableViewAgent.h"

@implementation AddOptionHideEditingViewController {
    AddAndEditableTableViewAgent *agent;
}

- (IBAction)touchEdit:(id)sender {
    [agent setEditing:!agent.editing];
}

- (void)didSelectAdditionalCell {
    [self performSegueWithIdentifier:kSegueEdit sender:[[ThirdViewObject alloc] initWithViewObject:nil]];
}

- (void)setAgent:(AddAndEditableTableViewAgent *)a {
    agent = a;
    [agent setAdditionalCellId:kReuseAdd];
    [agent setAdditionalCellMode:AdditionalCellModeHideEdting];
}

- (void)saveViewObject:(ThirdViewObject *)tvo {
    ViewObject *vo = (tvo.viewObject) ? : [[ViewObject alloc] init];
    vo.title = tvo.title;
    vo.message = tvo.message;
    
    if (tvo.viewObject == Nil) {
        [agent addViewObject:vo];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    agent.delegate = self;
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

- (void)deleteCell:(id)viewObject {
}

@end
