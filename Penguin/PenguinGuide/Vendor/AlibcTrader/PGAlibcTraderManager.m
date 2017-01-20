//
//  PGAlibcTraderManager.m
//  Penguin
//
//  Created by Jing Dai on 09/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

static NSString *const AppKey = @"23465992";

#import "PGAlibcTraderManager.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <AlibabaAuthSDK/ALBBSDK.h>

@interface PGAlibcTraderManager ()

@end

@implementation PGAlibcTraderManager

+ (void)registerAlibcTraderSDK
{
    [[AlibcTradeSDK sharedInstance] asyncInitWithSuccess:^{
        NSLog(@"AlibcSDK init successfully");
    } failure:^(NSError *error) {
        NSLog(@"AlibcSDK init failed: %@", [error description]);
    }];
    
#ifdef DEBUG
    [[AlibcTradeSDK sharedInstance] setDebugLogOpen:NO];
#else
    [[AlibcTradeSDK sharedInstance] setDebugLogOpen:NO];
#endif
}

+ (BOOL)handleOpenURL:(NSURL *)url
{
    return [[AlibcTradeSDK sharedInstance] handleOpenURL:url];
}

+ (BOOL)isUserLogin
{
    return [[ALBBSession sharedInstance] isLogin];
}

+ (void)login:(void (^)(BOOL success))completion
{
    [[ALBBSDK sharedInstance] auth:PGGlobal.tempNavigationController?PGGlobal.tempNavigationController:PGGlobal.rootNavigationController
                   successCallback:^(ALBBSession *session) {
                       if (completion) {
                           completion(YES);
                       }
                   } failureCallback:^(ALBBSession *session, NSError *error) {
                       if (completion) {
                           completion(NO);
                       }
                   }];
}

+ (void)logout
{
    [[ALBBSDK sharedInstance] logout];
}

+ (void)openGoodDetailPage:(NSString *)goodId native:(BOOL)showNative
{
    AlibcTradeShowParams *showParams = [[AlibcTradeShowParams alloc] init];
    if (showNative) {
        showParams.openType = ALiOpenTypeNative;
    } else {
        showParams.openType = ALiOpenTypeH5;
    }
    showParams.backUrl = [NSString stringWithFormat:@"tbopen%@:https://h5.m.taobao.com", AppKey];
    showParams.isNeedPush = YES;
    
    id <AlibcTradePage> goodDetailPage = [AlibcTradePageFactory itemDetailPage:goodId];
    
    [PGGlobal.rootNavigationController setNavigationBarHidden:NO animated:NO];
    
    if (PGGlobal.rootNavigationController) {
        NSInteger ret = [[AlibcTradeSDK sharedInstance].tradeService show:PGGlobal.tempNavigationController?PGGlobal.tempNavigationController:PGGlobal.rootNavigationController
                                                                     page:goodDetailPage
                                                               showParams:showParams
                                                              taoKeParams:nil
                                                               trackParam:nil
                                              tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
                                                  NSLog(@"open details page success: %@", result);
                                              } tradeProcessFailedCallback:^(NSError * _Nullable error) {
                                                  NSLog(@"open details page failed: %@", error);
                                              }];
        NSLog(@"open return code: %@", @(ret));
    }
}

+ (void)openMyOrdersPageWithNative:(BOOL)showNative
{
    AlibcTradeShowParams *showParams = [[AlibcTradeShowParams alloc] init];
    if (showNative) {
        showParams.openType = ALiOpenTypeNative;
    } else {
        showParams.openType = ALiOpenTypeH5;
    }
    showParams.backUrl = [NSString stringWithFormat:@"tbopen%@:https://h5.m.taobao.com", AppKey];
    showParams.isNeedPush = YES;
    
    id <AlibcTradePage> ordersPage = [AlibcTradePageFactory myOrdersPage:0 isAllOrder:NO];
    
    [PGGlobal.rootNavigationController setNavigationBarHidden:NO animated:NO];
    
    if (PGGlobal.rootNavigationController) {
        NSInteger ret = [[AlibcTradeSDK sharedInstance].tradeService show:PGGlobal.rootNavigationController
                                                                     page:ordersPage
                                                               showParams:showParams
                                                              taoKeParams:nil
                                                               trackParam:nil
                                              tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
                                                  NSLog(@"open orders page success: %@", result);
                                              } tradeProcessFailedCallback:^(NSError * _Nullable error) {
                                                  NSLog(@"open orders page failed: %@", error);
                                              }];
        NSLog(@"open return code: %@", @(ret));
    }
}

+ (void)openMyShoppingCartPageWithNative:(BOOL)showNative
{
    AlibcTradeShowParams *showParams = [[AlibcTradeShowParams alloc] init];
    if (showNative) {
        showParams.openType = ALiOpenTypeNative;
    } else {
        showParams.openType = ALiOpenTypeH5;
    }
    showParams.backUrl = [NSString stringWithFormat:@"tbopen%@:https://h5.m.taobao.com", AppKey];
    showParams.isNeedPush = YES;
    
    id<AlibcTradePage> shoppingCartPage = [AlibcTradePageFactory myCartsPage];
    
    [PGGlobal.rootNavigationController setNavigationBarHidden:NO animated:NO];
    
    if (PGGlobal.rootNavigationController) {
        NSInteger ret = [[AlibcTradeSDK sharedInstance].tradeService show:PGGlobal.rootNavigationController
                                                                     page:shoppingCartPage
                                                               showParams:showParams
                                                              taoKeParams:nil
                                                               trackParam:nil
                                              tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
                                                  NSLog(@"open success: %@", result);
                                              } tradeProcessFailedCallback:^(NSError * _Nullable error) {
                                                  NSLog(@"open failed: %@", [error description]);
                                              }];
        NSLog(@"open return code: %@", @(ret));
    }
}

@end
