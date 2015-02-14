//
//  AVOArrayViewController.m
//  TableViewAgent
//
//  Created by akuraru on 2015/02/07.
//  Copyright (c) 2015年 P.I.akura. All rights reserved.
//

#import "TableViewAgent.h"
#import "AVOArrayControoler.h"
#import "ViewObject.h"
#import "FRCAgentViewObject.h"
#import "ThirdViewController.h"
#import "ThirdViewObject.h"
#import "ExtactedID.h"

@interface AVOArrayViewController : UITableViewController <TableViewAgentDelegate>
@property(nonatomic) TableViewAgent *agent;
@property(nonatomic) AVOArrayController *arrayController;
@end

@implementation AVOArrayViewController {
}

- (IBAction)touchEdit:(id)sender {
    [self.agent setEditing:!self.agent.editing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.agent = [[TableViewAgent alloc] init];
    self.arrayController = [self createArrayController];
    self.agent.viewObjects = [self createAgentViewObject:self.arrayController];
    self.agent.delegate = self;
    [self.agent.viewObjects setEditableMode:EditableModeEnable];
}

- (AVOArrayController *)createArrayController {
    NSArray *viewObjects = @[
        [[ViewObject alloc] initWithTitle:@"hoge" message:@"A"],
        [[ViewObject alloc] initWithTitle:@"piyo" message:@"B"],
        [[ViewObject alloc] initWithTitle:@"fugafuga" message:@"A"],
    ];
    return [[AVOArrayController alloc] initWithArray:viewObjects groupedBy:@"message" withPredicate:nil sortedBy:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 message] compare:[obj2 message]];
    }];
}

- (FRCAgentViewObject *)createAgentViewObject:(id)arrayController {
    FRCAgentViewObject *agentViewObject = [[FRCAgentViewObject alloc] initWithFetch:arrayController];
    [agentViewObject setCellIdentifier:^NSString *(id viewObject) {
        return kReuseCustomTableViewCell;
    }];
    return agentViewObject;
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

    [self.agent redraw];
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
