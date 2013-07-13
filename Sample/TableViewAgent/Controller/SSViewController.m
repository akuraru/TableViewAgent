//
//  SSViewController.m
//  TableViewAgent
//
//  Created by P.I.akura on 2013/06/19.
//  Copyright (c) 2013年 P.I.akura. All rights reserved.
//

#import "SSViewController.h"
#import "SSTableViewAgent.h"
#import "ExtactedID.h"
#import "ThirdViewObject.h"
#import "ViewObject.h"

@interface SSViewController () <TableViewAgentDelegate>
@end

@implementation SSViewController{
    SSTableViewAgent *agent;
}

- (IBAction)touchEdit:(id)sender {
    [agent setEditing:!agent.editing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    agent = [[SSTableViewAgent alloc] init];
    agent.viewObjects = @[
     [[ViewObject alloc] initWithTitle:@"hoge" message:@"2012/12/11"],
     [[ViewObject alloc] initWithTitle:@"piyo" message:@"2012/05/31"],
     [[ViewObject alloc] initWithTitle:@"fugafuga" message:@"2012/04/03"],
     ];
    agent.delegate = self;
    [agent setAdditionalCellId:kReuseAdd];
    [agent setAdditionalCellMode:AdditionalCellModeHideEditing];
    [agent setEditableMode:EditableModeEnable];
}

- (void)saveViewObject:(ThirdViewObject *)tvo {
    ViewObject *vo = (tvo.viewObject) ? : [[ViewObject alloc] init];
    vo.title = tvo.title;
    vo.message = tvo.message;
    
    if (tvo.viewObject == Nil) {
        [agent addViewObject:vo];
    }
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
    [self performSegueWithIdentifier:kSegueEdit sender:[[ThirdViewObject alloc] initWithViewObject:viewObject]];
}
- (void)deleteCell:(id)viewObject {
}
- (void)didSelectAdditionalCell {
    [self performSegueWithIdentifier:kSegueEdit sender:[[ThirdViewObject alloc] initWithViewObject:nil]];
}

@end
