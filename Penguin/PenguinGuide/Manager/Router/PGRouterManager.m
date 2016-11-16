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
#import "PGScenarioViewController.h"
#import "PGTopicViewController.h"
#import "PGArticleViewController.h"
#import "PGGoodViewController.h"
#import "PGTagViewController.h"
#import "PGWebViewController.h"

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
    [[PGRouter sharedInstance] registerRoute:@"qiechihe://home" toHandler:^(NSDictionary *params) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate.tabBarController selectTab:0];
    }];
    
    [[PGRouter sharedInstance] registerRoute:@"qiechihe://login" toHandler:^(NSDictionary *params) {
        PGLoginViewController *loginVC = [[PGLoginViewController alloc] init];
        if (PGGlobal.rootNavigationController) {
            PGBaseNavigationController *navi = [[PGBaseNavigationController alloc] initWithRootViewController:loginVC];
            [PGGlobal.rootNavigationController presentViewController:navi animated:YES completion:nil];
        }
    }];
    
    [[PGRouter sharedInstance] registerRoute:@"qiechihe://topic" toHandler:^(NSDictionary *params) {
        if (PGGlobal.rootNavigationController) {
            if (params[@"topicId"]) {
                NSString *topicId = params[@"topicId"];
                PGTopicViewController *topicVC = [[PGTopicViewController alloc] initWithTopicId:topicId];
                [PGGlobal.rootNavigationController pushViewController:topicVC animated:YES];
            }
        }
    }];
    
    [[PGRouter sharedInstance] registerRoute:@"qiechihe://article" toHandler:^(NSDictionary *params) {
        if (PGGlobal.rootNavigationController) {
            if (params[@"articleId"]) {
                NSString *articleId = params[@"articleId"];
                PGArticleViewController *articleVC = [[PGArticleViewController alloc] initWithArticleId:articleId animated:NO];
                articleVC.disableTransition = NO;
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
    
    [[PGRouter sharedInstance] registerRoute:@"qiechihe://scenario" toHandler:^(NSDictionary *params) {
        if (PGGlobal.rootNavigationController) {
            if (params[@"scenarioId"]) {
                NSString *scenarioId = params[@"scenarioId"];
                PGScenarioViewController *scenarioVC = [[PGScenarioViewController alloc] initWithScenarioId:scenarioId];
                [PGGlobal.rootNavigationController pushViewController:scenarioVC animated:YES];
            }
        }
    }];
    
    [[PGRouter sharedInstance] registerRoute:@"http://" toHandler:^(NSDictionary *params) {
        if (PGGlobal.rootNavigationController) {
            if (params[@"web_url"]) {
                NSString *webUrl = params[@"web_url"];
                PGWebViewController *webVC = [[PGWebViewController alloc] initWithURL:webUrl];
                [PGGlobal.rootNavigationController pushViewController:webVC animated:YES];
            }
        }
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

+ (void)routeToScenarioPage:(NSString *)scenarioId link:(NSString *)link
{
    if (link && link.length > 0) {
        [[PGRouter sharedInstance] openURL:link];
    } else {
        NSString *url = [NSString stringWithFormat:@"qiechihe://scenario?scenarioId=%@", scenarioId];
        [[PGRouter sharedInstance] openURL:url];
    }
}

+ (void)routeToArticlePage:(NSString *)articleId link:(NSString *)link
{
    if (link && link.length > 0) {
        [[PGRouter sharedInstance] openURL:link];
    } else {
        NSString *url = [NSString stringWithFormat:@"qiechihe://article?articleId=%@", articleId];
        [[PGRouter sharedInstance] openURL:url];
    }
}

+ (void)routeToGoodDetailPage:(NSString *)goodId link:(NSString *)link
{
    if (link && link.length > 0) {
        [[PGRouter sharedInstance] openURL:link];
    } else {
        NSString *url = [NSString stringWithFormat:@"qiechihe://goods?goodsId=%@", goodId];
        [[PGRouter sharedInstance] openURL:url];
    }
}

@end
