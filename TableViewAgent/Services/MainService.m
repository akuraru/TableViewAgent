//
//  MainService.m
//  TableViewAgent
//
//  Created by P.I.akura on 2013/06/18.
//  Copyright (c) 2013年 P.I.akura. All rights reserved.
//

#import "MainService.h"
#import "ExtactedID.h"

@implementation MainService

- (NSArray *)segues {
    return @[kSegueSingleSection, kSegueMalutSection, kSegueFectedResult, kSegueArray, kSegueMergeSections, @"UnlimitedObjectWorks"];
}

- (NSString *)segue:(NSInteger)index {
    if (0 <= index && index < self.segues.count) {
        return self.segues[index];
    } else {
        return kSegueSingleSection;
    }
}

@end
