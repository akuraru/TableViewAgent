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
    TableViewAgentAdaptor *adaptor;
}

- (IBAction)touchEdit:(id)sender {
    [adaptor setEditing:![adaptor editing]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    adaptor = [[TableViewAgentAdaptor alloc] init];
    [adaptor setSigleSection:[self array]];
    [adaptor setDelegate:self];
    [adaptor setEditableModel:EditableModeEnable];
    [adaptor setAddMode:AdditionalCellModeHideEditing];
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
    
    [adaptor reload];
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
