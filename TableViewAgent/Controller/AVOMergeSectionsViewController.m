//
//  AVOMergeSectionsViewController.m
//  TableViewAgent
//
//  Created by akuraru on 2015/02/09.
//  Copyright (c) 2015年 P.I.akura. All rights reserved.
//

#import "TableViewAgent.h"
#import "AVOArrayControoler.h"
#import "ViewObject.h"
#import "FRCAgentViewObject.h"
#import "ThirdViewController.h"
#import "ThirdViewObject.h"
#import "ExtactedID.h"
#import "AVOMergeSections.h"
#import "AVOSingleRow.h"

@interface AVOMergeSectionsViewController : UITableViewController <TableViewAgentDelegate>
@property(nonatomic) TableViewAgent *agent;
@property(nonatomic) AVOArrayController *arrayController;
@end

@implementation AVOMergeSectionsViewController {
}

- (IBAction)touchEdit:(id)sender {
    [self.agent setEditing:!self.agent.editing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.agent = [[TableViewAgent alloc] init];

    self.arrayController = [self createArrayController];
    AVOMergeSections *mergeSections = [[AVOMergeSections alloc] initWithAgentViewObjects:@[
            [self createAgentViewController:self.arrayController],
            [self createSingleRow],
    ]];
    self.agent.viewObjects = mergeSections;
    self.agent.delegate = self;
}

- (AVOArrayController *)createArrayController {
    NSArray *viewObjects = @[
            [[ViewObject alloc] initWithTitle:@"hoge" message:@"A"],
            [[ViewObject alloc] initWithTitle:@"piyo" message:@"B"],
            [[ViewObject alloc] initWithTitle:@"fugafuga" message:@"A"],
    ];
    AVOArrayController *arrayController = [[AVOArrayController alloc] initWithArray:viewObjects groupedBy:@"message" withPredicate:nil sortedBy:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 message] compare:[obj2 message]];
    }];
    return arrayController;
}

- (FRCAgentViewObject *)createAgentViewController:(id)arrayController {
    FRCAgentViewObject *agentViewObject = [[FRCAgentViewObject alloc] initWithFetch:arrayController];
    [agentViewObject setEditableMode:EditableModeEnable];
    [agentViewObject setCellIdentifier:^NSString *(id viewObject) {
        return kReuseCustomTableViewCell;
    }];
    return agentViewObject;
}

- (AVOSingleRow *)createSingleRow {
    AVOSingleRow *singleRow = [[AVOSingleRow alloc] initWithViewObject:kReuseAdd];
    [singleRow setCellIdentifier:^NSString *(id viewObject) {
        return kReuseAdd;
    }];
    return singleRow;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kSegueEdit]) {
        ThirdViewController *controller = segue.destinationViewController;
        [controller setViewObject:sender];
        [controller setDelegate:self];
    }
}

#pragma -
#pragma mark TableViewAgentDelegate

- (void)didSelectCell:(id)viewObject {
    if ([viewObject isKindOfClass:[NSString class]]) {
        [self performSegueWithIdentifier:kSegueEdit sender:[[ThirdViewObject alloc] initWithViewObject:nil]];
    } else {
        [self performSegueWithIdentifier:kSegueEdit sender:[[ThirdViewObject alloc] initWithViewObject:viewObject]];
    }
}

- (void)deleteCell:(id)viewObject {
    [self.arrayController removeObject:viewObject];
}
@end
