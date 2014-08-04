//
//  MSViewController.m
//  TableViewAgent
//
//  Created by P.I.akura on 2013/08/18.
//  Copyright (c) 2013年 P.I.akura. All rights reserved.
//

#import "MSViewController.h"
#import "TableViewAgent-Swift.h"
#import "ExtactedID.h"
#import "ThirdViewObject.h"
#import "ViewObject.h"
#import "ThirdViewController.h"

@interface MSViewController () <TableViewAgentDelegate>

@end

@implementation MSViewController {
    TableViewAgentAdaptor *adaptor;
}

- (IBAction)touchEdit:(id)sender {
    [adaptor setEditing:![adaptor editing]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    adaptor = [[TableViewAgentAdaptor alloc] init];
    [adaptor setMultiSection:@[@[
                         [[ViewObject alloc] initWithTitle:@"hoge" message:@"2012/12/11"],
                         [[ViewObject alloc] initWithTitle:@"piyo" message:@"2012/05/31"],
                         ].mutableCopy, @[
                         [[ViewObject alloc] initWithTitle:@"fugafuga" message:@"2012/04/03"],
                         ].mutableCopy]];
    [adaptor setEditableModel:EditableModeEnable];
    [adaptor setAddMode:AdditionalCellModeShowEditing];
    [adaptor setDelegate:self];
}

- (void)saveViewObject:(ThirdViewObject *)tvo {
    if (tvo.viewObject) {
        ViewObject *vo = tvo.viewObject;
        vo.title = tvo.title;
        vo.message = tvo.message;
        
        [adaptor changeObject:vo];
    } else {
        ViewObject *vo = [[ViewObject alloc] init];
        vo.title = tvo.title;
        vo.message = tvo.message;
        
        [adaptor addObject:vo inSection:0];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    [self performSegueWithIdentifier:kSegueEdit sender:[[ThirdViewObject alloc] initWithViewObject:viewObject]];
}
- (void)deleteCell:(id)viewObject {
}
- (UIView *)sectionHeader:(id)viewObject {
    return ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        [label setText:[viewObject[0] message]];
        [label setBackgroundColor:[UIColor lightGrayColor]];
        label;
    });
}

- (NSString *)addCellIdentifier {
    return kReuseAdd;
}
- (void)didSelectAdditionalCell {
    [self performSegueWithIdentifier:kSegueEdit sender:[[ThirdViewObject alloc] initWithViewObject:nil]];
}

@end
