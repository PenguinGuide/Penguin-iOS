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
#import "PGAllScenariosViewController.h"
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
            if (PGGlobal.tempNavigationController) {
                [PGGlobal.tempNavigationController presentViewController:navi animated:YES completion:nil];
            } else {
                [PGGlobal.rootNavigationController presentViewController:navi animated:YES completion:nil];
            }
        }
    }];
    
    [[PGRouter sharedInstance] registerRoute:@"qiechihe://topic" toHandler:^(NSDictionary *params) {
        if (PGGlobal.rootNavigationController) {
            if (params[@"topicId"]) {
                NSString *topicId = params[@"topicId"];
                PGTopicViewController *topicVC = [[PGTopicViewController alloc] initWithTopicId:topicId];
                if (PGGlobal.tempNavigationController) {
                    [PGGlobal.tempNavigationController pushViewController:topicVC animated:YES];
                } else {
                    [PGGlobal.rootNavigationController pushViewController:topicVC animated:YES];
                }
            }
        }
    }];
    
    [[PGRouter sharedInstance] registerRoute:@"qiechihe://article" toHandler:^(NSDictionary *params) {
        if (PGGlobal.rootNavigationController) {
            if (params[@"articleId"]) {
                NSString *articleId = params[@"articleId"];
                PGArticleViewController *articleVC;
                if (params[@"animated"] && [params[@"animated"] isEqualToString:@"1"]) {
                    articleVC = [[PGArticleViewController alloc] initWithArticleId:articleId animated:YES];
                } else {
                    articleVC = [[PGArticleViewController alloc] initWithArticleId:articleId animated:NO];
                }
                articleVC.disableTransition = NO;
                if (PGGlobal.tempNavigationController) {
                    [PGGlobal.tempNavigationController pushViewController:articleVC animated:YES];
                } else {
                    [PGGlobal.rootNavigationController pushViewController:articleVC animated:YES];
                }
            }
        }
    }];
    
    [[PGRouter sharedInstance] registerRoute:@"qiechihe://goods" toHandler:^(NSDictionary *params) {
        if (PGGlobal.rootNavigationController) {
            if (params[@"goodsId"]) {
                NSString *goodId = params[@"goodsId"];
                PGGoodViewController *goodVC = [[PGGoodViewController alloc] initWithGoodId:goodId];
                if (PGGlobal.tempNavigationController) {
                    [PGGlobal.tempNavigationController pushViewController:goodVC animated:YES];
                } else {
                    [PGGlobal.rootNavigationController pushViewController:goodVC animated:YES];
                }
            }
        }
    }];
    
    [[PGRouter sharedInstance] registerRoute:@"qiechihe://tag" toHandler:^(NSDictionary *params) {
        if (PGGlobal.rootNavigationController) {
            if (params[@"tagId"]) {
                NSString *tagId = params[@"tagId"];
                PGTagViewController *tagVC = [[PGTagViewController alloc] initWithTagId:tagId];
                if (PGGlobal.tempNavigationController) {
                    [PGGlobal.tempNavigationController pushViewController:tagVC animated:YES];
                } else {
                    [PGGlobal.rootNavigationController pushViewController:tagVC animated:YES];
                }
            }
        }
    }];
    
    [[PGRouter sharedInstance] registerRoute:@"qiechihe://channel" toHandler:^(NSDictionary *params) {
        if (PGGlobal.rootNavigationController) {
            if (params[@"channelId"]) {
                NSString *categoryId = params[@"channelId"];
                PGChannelViewController *channelVC = [[PGChannelViewController alloc] initWithChannelId:categoryId];
                if (PGGlobal.tempNavigationController) {
                    [PGGlobal.tempNavigationController pushViewController:channelVC animated:YES];
                } else {
                    [PGGlobal.rootNavigationController pushViewController:channelVC animated:YES];
                }
            }
        }
    }];
    
    [[PGRouter sharedInstance] registerRoute:@"qiechihe://scenario" toHandler:^(NSDictionary *params) {
        if (PGGlobal.rootNavigationController) {
            if (params[@"scenarioId"]) {
                NSString *scenarioId = params[@"scenarioId"];
                if (params[@"fromStorePage"] && [params[@"fromStorePage"] isEqualToString:@"1"]) {
                    PGScenarioViewController *scenarioVC = [[PGScenarioViewController alloc] initWithScenarioId:scenarioId];
                    scenarioVC.isFromStorePage = YES;
                    if (PGGlobal.tempNavigationController) {
                        [PGGlobal.tempNavigationController pushViewController:scenarioVC animated:YES];
                    } else {
                        [PGGlobal.rootNavigationController pushViewController:scenarioVC animated:YES];
                    }
                } else {
                    PGScenarioViewController *scenarioVC = [[PGScenarioViewController alloc] initWithScenarioId:scenarioId];
                    scenarioVC.isFromStorePage = NO;
                    if (PGGlobal.tempNavigationController) {
                        [PGGlobal.tempNavigationController pushViewController:scenarioVC animated:YES];
                    } else {
                        [PGGlobal.rootNavigationController pushViewController:scenarioVC animated:YES];
                    }
                }
            }
        }
    }];
    
    [[PGRouter sharedInstance] registerRoute:@"qiechihe://all_scenarios" toHandler:^(NSDictionary *params) {
        if (PGGlobal.rootNavigationController) {
            if (params[@"scenarioType"]) {
                NSString *scenarioType = params[@"scenarioType"];
                PGAllScenariosViewController *allScenariosVC = [[PGAllScenariosViewController alloc] initWithScenarioType:scenarioType];
                if (PGGlobal.tempNavigationController) {
                    [PGGlobal.tempNavigationController pushViewController:allScenariosVC animated:YES];
                } else {
                    [PGGlobal.rootNavigationController pushViewController:allScenariosVC animated:YES];
                }
            }
        }
    }];
    
    [[PGRouter sharedInstance] registerRoute:@"http://" toHandler:^(NSDictionary *params) {
        if (PGGlobal.rootNavigationController) {
            if (params[@"web_url"]) {
                NSString *webUrl = params[@"web_url"];
                PGWebViewController *webVC = [[PGWebViewController alloc] initWithURL:webUrl];
                if (PGGlobal.tempNavigationController) {
                    [PGGlobal.tempNavigationController pushViewController:webVC animated:YES];
                } else {
                    [PGGlobal.rootNavigationController pushViewController:webVC animated:YES];
                }
            }
        }
    }];
    
    [[PGRouter sharedInstance] registerRoute:@"https://" toHandler:^(NSDictionary *params) {
        if (PGGlobal.rootNavigationController) {
            if (params[@"web_url"]) {
                NSString *webUrl = params[@"web_url"];
                PGWebViewController *webVC = [[PGWebViewController alloc] initWithURL:webUrl];
                if (PGGlobal.tempNavigationController) {
                    [PGGlobal.tempNavigationController pushViewController:webVC animated:YES];
                } else {
                    [PGGlobal.rootNavigationController pushViewController:webVC animated:YES];
                }
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

+ (void)routeToTopicPage:(NSString *)topicId link:(NSString *)link
{
    if (link && link.length > 0) {
        [[PGRouter sharedInstance] openURL:link];
    } else {
        NSString *url = [NSString stringWithFormat:@"qiechihe://topic?topicId=%@", topicId];
        [[PGRouter sharedInstance] openURL:url];
    }
}

+ (void)routeToScenarioPage:(NSString *)scenarioId link:(NSString *)link fromStorePage:(BOOL)fromStorePage
{
    if (link && link.length > 0) {
        if (fromStorePage) {
            [[PGRouter sharedInstance] openURL:[NSString stringWithFormat:@"%@&fromStorePage=1", link]];
        } else {
            [[PGRouter sharedInstance] openURL:link];
        }
    } else {
        if (fromStorePage) {
            NSString *url = [NSString stringWithFormat:@"qiechihe://scenario?scenarioId=%@&fromStorePage=1", scenarioId];
            [[PGRouter sharedInstance] openURL:url];
        } else {
            NSString *url = [NSString stringWithFormat:@"qiechihe://scenario?scenarioId=%@", scenarioId];
            [[PGRouter sharedInstance] openURL:url];
        }
    }
}

+ (void)routeToArticlePage:(NSString *)articleId link:(NSString *)link
{
    [PGRouterManager routeToArticlePage:articleId link:link animated:NO];
}

+ (void)routeToArticlePage:(NSString *)articleId link:(NSString *)link animated:(BOOL)animated
{
    if (link && link.length > 0) {
        if (animated) {
            if ([link containsString:@"?"]) {
                link = [link stringByAppendingString:@"&animated=1"];
            } else {
                link = [link stringByAppendingString:@"?animated=1"];
            }
        }
        [[PGRouter sharedInstance] openURL:link];
    } else {
        if (animated) {
            NSString *url = [NSString stringWithFormat:@"qiechihe://article?articleId=%@&animated=1", articleId];
            [[PGRouter sharedInstance] openURL:url];
        } else {
            NSString *url = [NSString stringWithFormat:@"qiechihe://article?articleId=%@", articleId];
            [[PGRouter sharedInstance] openURL:url];
        }
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

+ (void)routeToAllScenariosPage:(NSString *)scenarioType
{
    if (scenarioType && scenarioType.length > 0) {
        NSString *url = [NSString stringWithFormat:@"qiechihe://all_scenarios?scenarioType=%@", scenarioType];
        [[PGRouter sharedInstance] openURL:url];
    }
}

@end
