//
//  AppDelegate.m
//  TableViewAgent
//
//  Created by P.I.akura on 2013/06/15.
//  Copyright (c) 2013年 P.I.akura. All rights reserved.
//

#import "AppDelegate.h"
#import <MagicalRecord/MagicalRecord.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#ifdef TEST
#else
    [MagicalRecord setupCoreDataStack];
#endif
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
