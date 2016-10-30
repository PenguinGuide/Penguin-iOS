//
//  PGRouterManager.m
//  Penguin
//
//  Created by Jing Dai on 7/11/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGRouterManager.h"

// view controllers
#import "PGLoginViewController.h"
#import "PGHomeViewController.h"
#import "PGChannelViewController.h"
#import "PGTopicViewController.h"
#import "PGArticleViewController.h"
#import "PGGoodViewController.h"
#import "PGTagViewController.h"

@implementation PGRouterManager

+ (PGRouterManager *)sharedManager
{
    static PGRouterManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[PGRouterManager alloc] init];
    });
    
    return sharedManager;
}

+ (void)registerRouters
{
    [[PGRouter sharedInstance] registerRoute:@"qiechihe://login" toHandler:^(NSDictionary *params) {
        PGLoginViewController *loginVC = [[PGLoginViewController alloc] init];
        if (PGGlobal.rootNavigationController) {
            PGBaseNavigationController *navi = [[PGBaseNavigationController alloc] initWithRootViewController:loginVC];
            [PGGlobal.rootNavigationController presentViewController:navi animated:YES completion:nil];
        }
    }];
    
    [[PGRouter sharedInstance] registerRoute:@"qiechihe://topic" toHandler:^(NSDictionary *params) {
        if (PGGlobal.rootNavigationController) {
            PGTopicViewController *topicVC = [[PGTopicViewController alloc] initWithTopicId:@""];
            [PGGlobal.rootNavigationController pushViewController:topicVC animated:YES];
        }
    }];
    
    [[PGRouter sharedInstance] registerRoute:@"qiechihe://article" toHandler:^(NSDictionary *params) {
        if (PGGlobal.rootNavigationController) {
            if (params[@"articleId"]) {
                NSString *articleId = params[@"articleId"];
                PGArticleViewController *articleVC = [[PGArticleViewController alloc] initWithArticleId:articleId animated:NO];
                [PGGlobal.rootNavigationController pushViewController:articleVC animated:YES];
            }
        }
    }];
    
    [[PGRouter sharedInstance] registerRoute:@"qiechihe://goods" toHandler:^(NSDictionary *params) {
        if (PGGlobal.rootNavigationController) {
            if (params[@"goodsId"]) {
                NSString *goodId = params[@"goodsId"];
                PGGoodViewController *goodVC = [[PGGoodViewController alloc] initWithGoodId:goodId];
                [PGGlobal.rootNavigationController pushViewController:goodVC animated:YES];
            }
        }
    }];
    
    [[PGRouter sharedInstance] registerRoute:@"qiechihe://tag" toHandler:^(NSDictionary *params) {
        if (PGGlobal.rootNavigationController) {
            if (params[@"tagId"]) {
                NSString *tagId = params[@"tagId"];
                PGTagViewController *tagVC = [[PGTagViewController alloc] initWithTagId:tagId];
                [PGGlobal.rootNavigationController pushViewController:tagVC animated:YES];
            }
        }
    }];
    
    [[PGRouter sharedInstance] registerRoute:@"qiechihe://channel" toHandler:^(NSDictionary *params) {
        if (PGGlobal.rootNavigationController) {
            if (params[@"channelId"]) {
                NSString *categoryId = params[@"channelId"];
                PGChannelViewController *channelVC = [[PGChannelViewController alloc] initWithChannelId:categoryId];
                [PGGlobal.rootNavigationController pushViewController:channelVC animated:YES];
            }
        }
    }];
    
    [[PGRouter sharedInstance] registerRoute:@"qiechihe://home" toHandler:^(NSDictionary *params) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate.tabBarController selectTab:0];
    }];
}

+ (void)routeToLoginPage
{
    [[PGRouter sharedInstance] openURL:@"qiechihe://login"];
}

+ (void)routeToHomePage
{
    [[PGRouter sharedInstance] openURL:@"qiechihe://home"];
}

+ (void)routeToTopicPage
{
    [[PGRouter sharedInstance] openURL:@"qiechihe://topic"];
}

@end
