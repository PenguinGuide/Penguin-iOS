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
    [[AlibcTradeSDK sharedInstance] setDebugLogOpen:YES];
#else
    [[AlibcTradeSDK sharedInstance] setDebugLogOpen:NO];
#endif
}

+ (BOOL)handleOpenURL:(NSURL *)url
{
    return [[AlibcTradeSDK sharedInstance] handleOpenURL:url];
}

+ (void)openGoodDetailPage:(NSString *)goodId native:(BOOL)showNative
{
    AlibcTradeShowParams *showParams = [[AlibcTradeShowParams alloc] init];
    if (showNative) {
        showParams.openType = ALiOpenTypeNative;
        showParams.backUrl = [NSString stringWithFormat:@"tbopen%@:https://h5.m.taobao.com", AppKey];
        showParams.isNeedPush = YES;
    } else {
        showParams.openType = ALiOpenTypeH5;
    }
    
    id <AlibcTradePage> goodDetailPage = [AlibcTradePageFactory itemDetailPage:goodId];
    
    if (PGGlobal.rootNavigationController) {
        NSInteger ret = [[AlibcTradeSDK sharedInstance].tradeService show:PGGlobal.rootNavigationController
                                                                     page:goodDetailPage
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

+ (void)openMyOrdersPageWithNative:(BOOL)showNative
{
    
}

+ (void)openMyShoppingCartPageWithNative:(BOOL)showNative
{
    AlibcTradeShowParams *showParams = [[AlibcTradeShowParams alloc] init];
    if (showNative) {
        showParams.openType = ALiOpenTypeNative;
        showParams.backUrl = [NSString stringWithFormat:@"tbopen%@:https://h5.m.taobao.com", AppKey];
        showParams.isNeedPush = YES;
    } else {
        showParams.openType = ALiOpenTypeH5;
    }
    
    id<AlibcTradePage> shoppingCartPage = [AlibcTradePageFactory myCartsPage];
    
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