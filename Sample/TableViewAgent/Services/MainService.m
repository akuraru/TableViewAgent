//
//  MainService.m
//  TableViewAgent
//
//  Created by P.I.akura on 2013/06/18.
//  Copyright (c) 2013年 P.I.akura. All rights reserved.
//

#import "MainService.h"
#import "ExtactedID.h"
#import "HeightTableViewAgent.h"
#import "SSTableViewAgent.h"

@implementation MainService

- (NSArray *)segues {
    return @[kSegueSingleSection];
}

- (NSString *)segue:(NSInteger)index {
    if (0 <= index && index < self.segues.count) {
        return self.segues[index];
    } else {
        return kSegueSingleSection;
    }
}

- (TableViewAgent *)agentInstance:(NSInteger)index {
    switch (index) {
        case 0: return [[SSTableViewAgent alloc] init];
    }
    return [[TableViewAgent alloc] init];
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
