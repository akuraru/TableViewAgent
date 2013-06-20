//
// Created by P.I.akura on 2013/06/15.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SecondViewController.h"
#import "TableViewAgent.h"
#import "ViewObject.h"
#import "ExtactedID.h"
#import "ThirdViewController.h"

@implementation SecondViewController {
    TableViewAgent *agent;
}

- (void)setAgent:(TableViewAgent *)a {
    agent = a;
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

@end