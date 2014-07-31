//
//  SSViewController.m
//  TableViewAgent
//
//  Created by P.I.akura on 2013/06/19.
//  Copyright (c) 2013年 P.I.akura. All rights reserved.
//

#import "SSViewController.h"
#import "ExtactedID.h"
#import "ThirdViewObject.h"
#import "ViewObject.h"
#import "ThirdViewController.h"
#import "TableViewAgent-Swift.h"

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
    agent.viewObjects = [[SSAgentViewObject alloc] initWithArray:[self array] agent:agent];
    agent.delegate = self;
    [agent setEditableMode:EditableModeEnable];
    [agent setAdditionalCellMode:AdditionalCellModeHideEditing];
}
- (NSArray *)array {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:1000];
    for (int i = 0; i < 10; i++) {
        [result addObject:[[ViewObject alloc] initWithTitle:[@(arc4random()) stringValue] message:@"2012/12/11"]];
    }
    return result;
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
    
    [agent reload];
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
    return @"Cell";
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
