//
// Created by P.I.akura on 2013/06/18.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AddOptionNoneViewController.h"
#import "TableViewAgentCellDelegate.h"
#import "ExtactedID.h"
#import "ViewObject.h"
#import "AddAndEditableTableViewAgent.h"
#import "ThirdViewObject.h"
#import "AddAndEditableTableViewAgent.h"


@implementation AddOptionNoneViewController {
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
}
- (void)saveViewObject:(ThirdViewObject *)tvo {
    ViewObject *vo = (tvo.viewObject) ?: [[ViewObject alloc] init];
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