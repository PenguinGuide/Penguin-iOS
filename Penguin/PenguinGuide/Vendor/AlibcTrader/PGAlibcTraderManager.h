//
//  PGAlibcTraderManager.h
//  Penguin
//
//  Created by Jing Dai on 09/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGAlibcTraderManager : NSObject

+ (void)registerAlibcTraderSDK;
+ (BOOL)handleOpenURL:(NSURL *)url;

+ (void)openGoodDetailPage:(NSString *)goodId native:(BOOL)showNative;
+ (void)openMyOrdersPageWithNative:(BOOL)showNative;
+ (void)openMyShoppingCartPageWithNative:(BOOL)showNative;

@end
