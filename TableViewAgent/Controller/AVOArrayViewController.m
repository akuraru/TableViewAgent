//
//  AVOArrayViewController.m
//  TableViewAgent
//
//  Created by akuraru on 2015/02/07.
//  Copyright (c) 2015年 P.I.akura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableViewAgent.h"
#import "AVOArrayControoler.h"
#import "ViewObject.h"
#import "FRCAgentViewObject.h"
#import "ThirdViewController.h"
#import "ThirdViewObject.h"
#import "ExtactedID.h"

@interface AVOArrayViewController : UITableViewController <TableViewAgentDelegate>
@property (nonatomic) AVOArrayController *arrayController;
@end

@implementation AVOArrayViewController{
    TableViewAgent *agent;
}

- (IBAction)touchEdit:(id)sender {
    [agent setEditing:!agent.editing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    agent = [[TableViewAgent alloc] init];
    NSArray *viewObjects = @[
                             [[ViewObject alloc] initWithTitle:@"hoge" message:@"A"],
                             [[ViewObject alloc] initWithTitle:@"piyo" message:@"B"],
                             [[ViewObject alloc] initWithTitle:@"fugafuga" message:@"A"],
                             ];
    self.arrayController = [[AVOArrayController alloc] initWithArray:viewObjects groupedBy:@"message" withPredicate:nil sortedBy:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 message] compare:[obj2 message]];
    }];
    agent.viewObjects = [[FRCAgentViewObject alloc]initWithFetch:(id)self.arrayController];
    agent.delegate = self;
    [agent setEditableMode:EditableModeEnable];
    [agent setAdditionalCellMode:AdditionalCellModeHideEditing];
}

- (void)saveViewObject:(ThirdViewObject *)tvo {
    if (tvo.viewObject) {
        ViewObject *vo = tvo.viewObject;
        vo.title = tvo.title;
        vo.message = tvo.message;
        
        [self.arrayController updateObject:vo];
    } else {
        ViewObject *vo = [[ViewObject alloc] init];
        vo.title = tvo.title;
        vo.message = tvo.message;
        
        [self.arrayController addObject:vo];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [agent redraw];
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
    return kReuseCustomTableViewCell;
}

- (void)didSelectCell:(ViewObject *)viewObject {
    [self performSegueWithIdentifier:kSegueEdit sender:[[ThirdViewObject alloc] initWithViewObject:viewObject]];
}
- (void)deleteCell:(id)viewObject {
    [self.arrayController removeObject:viewObject];
}

- (NSString *)addCellIdentifier {
    return kReuseAdd;
}
- (void)didSelectAdditionalCell {
    [self performSegueWithIdentifier:kSegueEdit sender:[[ThirdViewObject alloc] initWithViewObject:nil]];
}
@end
