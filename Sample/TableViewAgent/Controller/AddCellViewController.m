//
// Created by P.I.akura on 2013/06/16.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AddCellViewController.h"
#import "TableViewAgentCellDelegate.h"
#import "ExtactedID.h"
#import "ViewObject.h"
#import "TableViewAgent.h"
#import "ThirdViewObject.h"
#import "AddCellTableViewAgent.h"
#import "AddCellTableViewAgent.h"


@implementation AddCellViewController {
    AddCellTableViewAgent *agent;
}

- (IBAction)touchAdd:(id)sender {
    [self performSegueWithIdentifier:kSegueEdit sender:[[ThirdViewObject alloc] initWithViewObject:nil]];
}

- (void)setAgent:(AddCellTableViewAgent *)a {
    agent = a;
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
@end