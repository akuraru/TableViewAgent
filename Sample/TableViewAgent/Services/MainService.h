//
//  MainService.h
//  TableViewAgent
//
//  Created by P.I.akura on 2013/06/18.
//  Copyright (c) 2013年 P.I.akura. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TableViewAgent;

@interface MainService : NSObject

- (NSString *)segue:(NSInteger)index;
- (TableViewAgent *)agentInstance:(NSInteger)index;
- (BOOL)existSegues:(NSString *)string;

@end
