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
#import "PGTopicViewController.h"
#import "PGArticleViewController.h"
#import "PGGoodViewController.h"

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
        PGLoginViewController *loginVC = [[PGLoginViewController alloc] initWithScreenshot:[[(AppDelegate *)[UIApplication sharedApplication].delegate window] screenshot]];
        if (PGGlobal.rootNavigationController) {
            loginVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [PGGlobal.rootNavigationController presentViewController:loginVC animated:YES completion:nil];
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
            NSString *articleId = params[@"article_id"];
            PGArticleViewController *articleVC = [[PGArticleViewController alloc] initWithArticleId:articleId animated:NO];
            [PGGlobal.rootNavigationController pushViewController:articleVC animated:YES];
        }
    }];
    
    [[PGRouter sharedInstance] registerRoute:@"qiechihe://good" toHandler:^(NSDictionary *params) {
        if (PGGlobal.rootNavigationController) {
            NSString *goodId = params[@"good_id"];
            PGGoodViewController *goodVC = [[PGGoodViewController alloc] initWithGoodId:goodId];
            [PGGlobal.rootNavigationController pushViewController:goodVC animated:YES];
        }
    }];
}

+ (void)routeToLoginPage
{
    [[PGRouter sharedInstance] openURL:@"qiechihe://login"];
}

+ (void)routeToTopicPage
{
    [[PGRouter sharedInstance] openURL:@"qiechihe://topic"];
}

@end
