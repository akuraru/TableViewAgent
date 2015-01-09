//
// Created by P.I.akura on 2013/09/27.
// Copyright (c) 2013 P.I.akura. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "FRCViewController.h"
#import "ExtactedID.h"
#import "ThirdViewObject.h"
#import "ViewObject.h"
#import "TodoManager.h"
#import "WETodo.h"
#import "ThirdViewController.h"
#import "TableViewAgent-Swift.h"
#import "Enum.h"

@interface FRCViewController () <TableViewAgentDelegate>
@end

@implementation FRCViewController {
    TableViewAgentAdaptor *adaptor;
}

- (IBAction)touchEdit:(id)sender {
    [adaptor setEditing:![adaptor editing]];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    adaptor = [[TableViewAgentAdaptor alloc] init];
    [adaptor setFetchedResultController:[TodoManager fetchController]];
    [adaptor setDelegate:self];
    [adaptor setEditableModel:EditableModeEnable];
    [adaptor setAddMode:AdditionalCellModeAlways];
}

- (void)saveViewObject:(WETodo *)we {
    [TodoManager updateEntity:we];
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
    [self performSegueWithIdentifier:kSegueEdit sender:[[WETodo alloc] initWithTodo:viewObject]];
}
- (void)deleteCell:(id)viewObject {
    [TodoManager deleteEntity:viewObject];
}
- (NSString *)sectionTitle:(id)viewObjects {
    return [viewObjects title];
}

- (NSString *)addCellIdentifier {
    return kReuseAdd;
}
- (void)didSelectAdditionalCell {
    [self performSegueWithIdentifier:kSegueEdit sender:[[WETodo alloc] initWithTodo:nil]];
}
@end