//
//  AppDelegate.m
//  PenguinGuide
//
//  Created by Jing Dai on 6/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "AppDelegate.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#import "PGThemeManager.h"
#import "PGRouterManager.h"

#import "PGBaseNavigationController.h"

#import "PGHomeViewController.h"
#import "PGExploreViewController.h"
#import "PGStoreViewController.h"
#import "PGMeViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong, readwrite) PGTabBarController *tabBarController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Fabric
    [Fabric with:@[[Crashlytics class]]];
    // Theme
    [PGThemeManager sharedManager];
    // Router
    [PGRouterManager registerRouters];
    // Log
#ifdef DEBUG
    [PGLog setup];
#else
    [PGLog turnOffLogging];
#endif
    
    PGHomeViewController *homeVC = [[PGHomeViewController alloc] init];
    PGExploreViewController *exploreVC = [[PGExploreViewController alloc] init];
    PGStoreViewController *storeVC = [[PGStoreViewController alloc] init];
    PGMeViewController *meVC = [[PGMeViewController alloc] init];
    
    self.tabBarController = [[PGTabBarController alloc] init];
    [self.tabBarController setViewControllers:@[homeVC, exploreVC, storeVC, meVC]];
    
    PGBaseNavigationController *navigationController = [[PGBaseNavigationController alloc] initWithRootViewController:self.tabBarController];
    PGGlobal.rootNavigationController = navigationController;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
