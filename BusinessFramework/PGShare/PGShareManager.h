//
//  PGShareManager.h
//  Pods
//
//  Created by Jing Dai on 6/27/16.
//
//

#import <Foundation/Foundation.h>
// sharesdk
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
// qq
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
// weixin
#import "WXApi.h"
// weibo
#import "WeiboSDK.h"
// share item
#import "PGShareItem.h"

@interface PGShareManager : NSObject

+ (void)registerShareSDK;

//+ (void)shareItem:(PGShareItem *)shareItem toPlatform:(SSDKPlatformType)platformType;

+ (void)shareItem:(void(^)(PGShareItem *shareItem))itemBlock toPlatform:(SSDKPlatformType)platformType completion:(void(^)(BOOL success))completion;

+ (void)loginWithWechatOnStateChanged:(SSDKGetUserStateChangedHandler)stateChangedHandler;
+ (void)loginWithWeiboOnStateChanged:(SSDKGetUserStateChangedHandler)stateChangedHandler;

@end
