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
#import "PGAnalytics.h"

#import <SDWebImage/SDWebImageDownloader.h>
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/SDImageCacheConfig.h>

#import "AFNetworkReachabilityManager.h"

#import "PGBaseNavigationController.h"

#import "PGStoreViewController.h"
#import "PGExploreViewController.h"
#import "PGCityGuideViewController.h"
#import "PGMeViewController.h"

#import "PGLaunchGuidesViewController.h"

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
    
    // SDWebImage
    // NOTE: decodeImage causes a lot of memorys: http://blog.csdn.net/xiaobai20131118/article/details/50682062
    [SDWebImageDownloader.sharedDownloader setShouldDecompressImages:NO];
    [SDImageCache.sharedImageCache.config setShouldDecompressImages:NO];
    
    // AFNetworking
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [PGShareManager registerShareSDK];
    [PGAlibcTraderManager registerAlibcTraderSDK];
    [PGAnalytics setup:launchOptions];
    
    // Remote Notifications
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    //[PGLaunchAds sharedInstance];
    PGStoreViewController *storeVC = [[PGStoreViewController alloc] init];
    PGCityGuideViewController *cityGuideVC = [[PGCityGuideViewController alloc] init];
    PGExploreViewController *exploreVC = [[PGExploreViewController alloc] init];
    PGMeViewController *meVC = [[PGMeViewController alloc] init];
    
    self.tabBarController = [[PGTabBarController alloc] init];
    [self.tabBarController setViewControllers:@[storeVC, exploreVC, cityGuideVC, meVC]];
    
    __block PGBaseNavigationController *navigationController = [[PGBaseNavigationController alloc] initWithRootViewController:self.tabBarController];
    PGGlobal.rootNavigationController = navigationController;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    BOOL isFirstLaunch = NO;
    NSString *currentVersion = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSArray *appVersion = [PGGlobal.cache objectForKey:@"app_version" fromTable:@"Session"];
    if (appVersion && [appVersion isKindOfClass:[NSArray class]]) {
        NSString *savedVersion = appVersion.firstObject;
        if (![savedVersion isEqualToString:currentVersion]) {
            isFirstLaunch = YES;
            [PGGlobal.cache putObject:@[currentVersion] forKey:@"app_version" intoTable:@"Session"];
        }
    } else {
        isFirstLaunch = YES;
        [PGGlobal.cache putObject:@[currentVersion] forKey:@"app_version" intoTable:@"Session"];
    }
    
    if (isFirstLaunch) {
        PGLaunchGuidesViewController *launchGuidesVC = [[PGLaunchGuidesViewController alloc] initWithImages:@[@"launch_guides_1", @"launch_guides_2", @"launch_guides_3", @"launch_guides_4"]];
        PGWeakSelf(self);
        [launchGuidesVC setCompletionBlock:^{
            weakself.window.rootViewController = navigationController;
        }];
        PGBaseNavigationController *launchGuidesNaviController = [[PGBaseNavigationController alloc] initWithRootViewController:launchGuidesVC];
        self.window.rootViewController = launchGuidesNaviController;
    } else {
        self.window.rootViewController = navigationController;
    }
    
    [self.window makeKeyAndVisible];
    
    [NSThread sleepForTimeInterval:1.5f];
    
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
    
    if (token && token.length > 0) {
        [PGGlobal.cache putObject:@[token] forKey:@"apns_token" intoTable:@"Session"];
    }
    
    [PGGlobal registerAPNSToken:token];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    if (userInfo[@"type"]) {
#if (defined DEBUG)
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        if (!error) {
            NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [[[UIAlertView alloc] initWithTitle:@"notification userinfo"
                                       message:dataStr
                                      delegate:nil
                             cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil] show];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"notification userinfo"
                                        message:@"bad format"
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil] show];
        }
#endif
        
        NSString *notificationType = [NSString stringWithFormat:@"%@", userInfo[@"type"]];
        if ([notificationType isEqualToString:@"1"]) {
            // h5
            if (userInfo[@"url"]) {
                NSString *url = [NSString stringWithFormat:@"%@", userInfo[@"url"]];
                if (url && url.length > 0) {
                    [[PGRouter sharedInstance] openURL:url];
                }
            }
        } else if ([notificationType isEqualToString:@"2"]) {
            // good detail
            if (userInfo[@"id"]) {
                NSString *goodId = [NSString stringWithFormat:@"%@", userInfo[@"id"]];
                if (goodId && goodId.length > 0) {
                    [PGRouterManager routeToGoodDetailPage:goodId link:nil];
                }
            }
        } else if ([notificationType isEqualToString:@"3"]) {
            // article
            if (userInfo[@"id"]) {
                NSString *articleId = [NSString stringWithFormat:@"%@", userInfo[@"id"]];
                if (articleId && articleId.length > 0) {
                    [PGRouterManager routeToArticlePage:articleId link:nil];
                }
            }
        } else if ([notificationType isEqualToString:@"4"]) {
            // topic
            if (userInfo[@"id"]) {
                NSString *topicId = [NSString stringWithFormat:@"%@", userInfo[@"id"]];
                if (topicId && topicId.length > 0) {
                    [PGRouterManager routeToTopicPage:topicId link:nil];
                }
            }
        } else if ([notificationType isEqualToString:@"5"]) {
            // scenario
            if (userInfo[@"id"]) {
                NSString *scenarioId = [NSString stringWithFormat:@"%@", userInfo[@"id"]];
                if (scenarioId && scenarioId.length > 0) {
                    [PGRouterManager routeToScenarioPage:scenarioId link:nil fromStorePage:NO];
                }
            }
        } else if ([notificationType isEqualToString:@"6"]) {
            // system message
        } else if ([notificationType isEqualToString:@"7"]) {
            // version update
        } else if ([notificationType isEqualToString:@"8"]) {
            // rate app
        }
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (userInfo[@"type"]) {
#if (defined DEBUG)
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        if (!error) {
            NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [[[UIAlertView alloc] initWithTitle:@"notification userinfo"
                                        message:dataStr
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil] show];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"notification userinfo"
                                        message:@"bad format"
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil] show];
        }
#endif
        
        NSString *notificationType = [NSString stringWithFormat:@"%@", userInfo[@"type"]];
        if ([notificationType isEqualToString:@"1"]) {
            // h5
            if (userInfo[@"url"]) {
                NSString *url = [NSString stringWithFormat:@"%@", userInfo[@"url"]];
                if (url && url.length > 0) {
                    [[PGRouter sharedInstance] openURL:url];
                }
            }
        } else if ([notificationType isEqualToString:@"2"]) {
            // good detail
            if (userInfo[@"id"]) {
                NSString *goodId = [NSString stringWithFormat:@"%@", userInfo[@"id"]];
                if (goodId && goodId.length > 0) {
                    [PGRouterManager routeToGoodDetailPage:goodId link:nil];
                }
            }
        } else if ([notificationType isEqualToString:@"3"]) {
            // article
            if (userInfo[@"id"]) {
                NSString *articleId = [NSString stringWithFormat:@"%@", userInfo[@"id"]];
                if (articleId && articleId.length > 0) {
                    [PGRouterManager routeToArticlePage:articleId link:nil];
                }
            }
        } else if ([notificationType isEqualToString:@"4"]) {
            // topic
            if (userInfo[@"id"]) {
                NSString *topicId = [NSString stringWithFormat:@"%@", userInfo[@"id"]];
                if (topicId && topicId.length > 0) {
                    [PGRouterManager routeToTopicPage:topicId link:nil];
                }
            }
        } else if ([notificationType isEqualToString:@"5"]) {
            // scenario
            if (userInfo[@"id"]) {
                NSString *scenarioId = [NSString stringWithFormat:@"%@", userInfo[@"id"]];
                if (scenarioId && scenarioId.length > 0) {
                    [PGRouterManager routeToScenarioPage:scenarioId link:nil fromStorePage:NO];
                }
            }
        } else if ([notificationType isEqualToString:@"6"]) {
            // system message
        }
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
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
    
    if ([PGGlobal.cache objectForKey:@"apns_token" fromTable:@"Session"]) {
        NSArray *tokenObject = [PGGlobal.cache objectForKey:@"apns_token" fromTable:@"Session"];
        if (tokenObject && [tokenObject isKindOfClass:[NSArray class]]) {
            NSString *token = [tokenObject firstObject];
            if (token && token.length > 0) {
                [PGGlobal registerAPNSToken:token];
            }
        }
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
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
