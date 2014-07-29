//
// Created by akuraru on 2014/07/11.
// Copyright (c) 2014 P.I.akura. All rights reserved.
//

#import "MainEntry.h"
#import "SSViewController.h"


@implementation MainEntry {

}
- (SSViewController *)ss {
    return [self viewController:@"SSViewController"];
}

+ (NSString *)storyboardName {
    return @"MainStoryboard";
}
@end