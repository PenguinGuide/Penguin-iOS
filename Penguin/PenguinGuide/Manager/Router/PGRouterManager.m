//
//  PGRouterManager.m
//  Penguin
//
//  Created by Jing Dai on 7/11/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGRouterManager.h"
#import "PGRouter.h"

// view controllers
#import "PGLoginViewController.h"

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
}

+ (void)routeToLoginPage
{
    [[PGRouter sharedInstance] openURL:@"qiechihe://login"];
}

@end
