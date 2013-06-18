//
//  MainService.m
//  TableViewAgent
//
//  Created by P.I.akura on 2013/06/18.
//  Copyright (c) 2013年 P.I.akura. All rights reserved.
//

#import "MainService.h"
#import "ExtactedID.h"
#import "SimpleTableViewAgent.h"
#import "SelectCellTableViewAgent.h"
#import "EditableTableViewAgent.h"
#import "AddCellTableViewAgent.h"
#import "AdditionalCellTableViewAgent.h"
#import "AddAndEditableTableViewAgent.h"

@implementation MainService

- (NSArray *)segues {
    return @[kSegueAgent, kSegueSelect, kSegueEditable, kSegueAdd, kSegueAdditionalCell, kSegueAddAndEditNone, kSegueAddAndEditHideEditing, kSegueAddAndEditShowEditing];
}

- (NSString *)segue:(NSInteger)index {
    if (0 <= index && index < self.segues.count)
        return self.segues[index];
    else
        return kSegueAgent;
}


- (TableViewAgent *)agentInstance:(NSInteger)index {
    switch (index) {
        case 0 : return [[SimpleTableViewAgent alloc] init];
        case 1 : return [[SelectCellTableViewAgent alloc] init];
        case 2 : return [[EditableTableViewAgent alloc] init];
        case 3 : return [[AddCellTableViewAgent alloc] init];
        case 4 : return [[AdditionalCellTableViewAgent alloc] init];
        case 5 : return [[AddAndEditableTableViewAgent alloc] init];
        case 6 : return [[AddAndEditableTableViewAgent alloc] init];
        case 7 : return [[AddAndEditableTableViewAgent alloc] init];
    }
    return [[SimpleTableViewAgent alloc] init];
}

- (BOOL)existSegues:(NSString *)string {
    for (NSString *segue in self.segues) {
        if ([segue isEqualToString:string]) {
            return YES;
        }
    }
    return NO;
}
@end
