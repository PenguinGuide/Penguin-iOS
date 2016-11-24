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
#import "PGShareManager.h"
#import "PGLaunchAds.h"
#import "PGAlibcTraderManager.h"

#import "PGBaseNavigationController.h"

#import "PGHomeViewController.h"
#import "PGExploreViewController.h"
#import "PGStoreViewController.h"
#import "PGMeViewController.h"

#import "PGAnalytics.h"

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
    [PGAPIClient enableLogging];
#else
    [PGLog turnOffLogging];
    [PGAPIClient disableLogging];
#endif
    
    [PGShareManager registerShareSDK];
    [PGAlibcTraderManager registerAlibcTraderSDK];
    [PGAnalytics setup:launchOptions];
    
    // Remote Notifications
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                             categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    //[PGLaunchAds sharedInstance];
    PGHomeViewController *homeVC = [[PGHomeViewController alloc] init];
    PGExploreViewController *exploreVC = [[PGExploreViewController alloc] init];
    PGStoreViewController *storeVC = [[PGStoreViewController alloc] init];
    PGMeViewController *meVC = [[PGMeViewController alloc] init];
    
    self.tabBarController = [[PGTabBarController alloc] init];
    [self.tabBarController setViewControllers:@[storeVC, exploreVC, homeVC, meVC]];
    
    PGBaseNavigationController *navigationController = [[PGBaseNavigationController alloc] initWithRootViewController:self.tabBarController];
    PGGlobal.rootNavigationController = navigationController;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // 如果阿里百川处理过会返回YES
    BOOL isHandled = [PGAlibcTraderManager handleOpenURL:url];
    
    if (!isHandled) {
        
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    // 如果阿里百川处理过会返回YES - iOS 9
    BOOL isHandled = [PGAlibcTraderManager handleOpenURL:url];
    
    if (!isHandled) {
        
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

/*
 * Each time your app runs on a device, it fetches this token from APNs and forwards it to your provider.
 * Your provider stores the token and uses it when sending notifications to that particular app and device.
 * The token itself is opaque and persistent, changing only when a device’s data and settings are erased
 * Only APNs can decode and read a device token.
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
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
    [PGGlobal updateTimer];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (self.allowRotation) {
        return UIInterfaceOrientationMaskAll;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

@end
