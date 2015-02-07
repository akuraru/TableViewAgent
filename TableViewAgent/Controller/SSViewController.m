//
//  SSViewController.m
//  TableViewAgent
//
//  Created by P.I.akura on 2013/06/19.
//  Copyright (c) 2013年 P.I.akura. All rights reserved.
//

#import "SSViewController.h"
#import "TableViewAgent.h"
#import "ExtactedID.h"
#import "ThirdViewObject.h"
#import "ViewObject.h"
#import "SSAgentViewObject.h"
#import "ThirdViewController.h"

@interface SSViewController () <TableViewAgentDelegate>
@end

@implementation SSViewController {
    TableViewAgent *agent;
}

- (IBAction)touchEdit:(id)sender {
    [agent setEditing:!agent.editing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    agent = [[TableViewAgent alloc] init];
    agent.viewObjects = [[SSAgentViewObject alloc] initWithArray:@[
     [[ViewObject alloc] initWithTitle:@"hoge" message:@"2012/12/11"],
     [[ViewObject alloc] initWithTitle:@"piyo" message:@"2012/05/31"],
     [[ViewObject alloc] initWithTitle:@"fugafuga" message:@"2012/04/03"],
     ]];
    agent.delegate = self;
    [agent setEditableMode:EditableModeEnable];
    [agent setAdditionalCellMode:AdditionalCellModeHideEditing];
}

- (void)saveViewObject:(ThirdViewObject *)tvo {
    if (tvo.viewObject) {
        ViewObject *vo = tvo.viewObject;
        vo.title = tvo.title;
        vo.message = tvo.message;
        
        id viewObjects = agent.viewObjects;
        [viewObjects changeObject:vo];
    } else {
        ViewObject *vo = [[ViewObject alloc] init];
        vo.title = tvo.title;
        vo.message = tvo.message;
            
        id viewObjects = agent.viewObjects;
        [viewObjects addObject:vo];
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
    return kReuseCustomTableViewCell;
}

- (void)didSelectCell:(ViewObject *)viewObject {
    //[self performSegueWithIdentifier:kSegueEdit sender:[[ThirdViewObject alloc] initWithViewObject:viewObject]];
}
- (void)deleteCell:(id)viewObject {
}

- (NSString *)addCellIdentifier {
    return kReuseAdd;
}
- (void)didSelectAdditionalCell {
    [self performSegueWithIdentifier:kSegueEdit sender:[[ThirdViewObject alloc] initWithViewObject:nil]];
}
@end
