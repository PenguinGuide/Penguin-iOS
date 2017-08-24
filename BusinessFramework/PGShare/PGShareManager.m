//
//  PGShareManager.m
//  Pods
//
//  Created by Jing Dai on 6/27/16.
//
//

NSString *const sdkKey = @"145aaacfc8950";

NSString *const WeixinAppId = @"wxc6b9a21b374107ba";
NSString *const WeixinAppSecret = @"f760489f7e86e265c623c44c6cb54da2";
NSString *const WeiboAppKey = @"1943859143";
NSString *const WeiboAppSecret = @"fcb5a4ca57d16b1462997c4441935e38";

#import "PGShareManager.h"

@implementation PGShareManager

+ (void)registerShareSDK
{
    [ShareSDK registerActivePlatforms:@[@(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformTypeSinaWeibo)]
                             onImport:^(SSDKPlatformType platformType) {
                                 switch (platformType) {
                                     case SSDKPlatformTypeWechat:
                                         [ShareSDKConnector connectWeChat:[WXApi class]];
                                         break;
                                     case SSDKPlatformTypeSinaWeibo:
                                         [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                                         break;
                                     default:
                                         break;
                                 }
                             } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                                 switch (platformType) {
                                     case SSDKPlatformTypeWechat:
                                         [appInfo SSDKSetupWeChatByAppId:WeixinAppId
                                                               appSecret:WeixinAppSecret];
                                         break;
                                     case SSDKPlatformTypeSinaWeibo:
                                         [appInfo SSDKSetupSinaWeiboByAppKey:WeiboAppKey
                                                                   appSecret:WeiboAppSecret
                                                                 redirectUri:@"https://m.penguinguide.cn"
                                                                    authType:SSDKAuthTypeBoth];
                                     default:
                                         break;
                                 }
                             }];
}

+ (BOOL)isWechatInstalled
{
    return [WXApi isWXAppInstalled];
}

+ (BOOL)isWeiboInstalled
{
    return [WeiboSDK isWeiboAppInstalled];
}

+ (void)shareItem:(void (^)(PGShareItem *shareItem))itemBlock toPlatform:(SSDKPlatformType)platformType completion:(void (^)(SSDKResponseState state))completion
{
    PGShareItem *shareItem = [[PGShareItem alloc] init];
    itemBlock(shareItem);
    
    switch (platformType) {
        case SSDKPlatformSubTypeWechatTimeline:
            [PGShareManager shareToWechatTimeline:shareItem completion:completion];
            break;
        case SSDKPlatformSubTypeWechatSession:
            [PGShareManager shareToWechatSession:shareItem completion:completion];
            break;
        case SSDKPlatformTypeSinaWeibo:
            [PGShareManager shareToWeibo:shareItem completion:completion];
            break;
        default:
            break;
    }
}

+ (void)loginWithWechatOnStateChanged:(SSDKGetUserStateChangedHandler)stateChangedHandler
{
    // NOTE: LSApplicationQueriesSchemes need configured for iOS 9+
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
               if (stateChangedHandler) {
                   stateChangedHandler(state, user, error);
               }
           }];
}

+ (void)loginWithWeiboOnStateChanged:(SSDKGetUserStateChangedHandler)stateChangedHandler
{
    [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
               if (stateChangedHandler) {
                   stateChangedHandler(state, user, error);
               }
           }];
}

+ (void)logout
{
    [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
    [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
}

#pragma mark - <Private Methods>

+ (void)shareToWechatTimeline:(PGShareItem *)shareItem completion:(void (^)(SSDKResponseState state))completion
{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    [shareParams SSDKSetupWeChatParamsByText:shareItem.text
                                       title:shareItem.title
                                         url:[NSURL URLWithString:shareItem.url]
                                  thumbImage:shareItem.thumbnailImage
                                       image:shareItem.image
                                musicFileURL:nil
                                     extInfo:nil
                                    fileData:nil
                                emoticonData:nil
                                        type:SSDKContentTypeWebPage
                          forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    
    [ShareSDK share:SSDKPlatformSubTypeWechatTimeline
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         if (completion) {
             completion(state);
         }
     }];
}

+ (void)shareToWechatSession:(PGShareItem *)shareItem completion:(void (^)(SSDKResponseState state))completion
{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    [shareParams SSDKSetupWeChatParamsByText:shareItem.text
                                       title:shareItem.title
                                         url:[NSURL URLWithString:shareItem.url]
                                  thumbImage:shareItem.thumbnailImage
                                       image:shareItem.image
                                musicFileURL:nil
                                     extInfo:nil
                                    fileData:nil
                                emoticonData:nil
                                        type:SSDKContentTypeWebPage
                          forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    
    [ShareSDK share:SSDKPlatformSubTypeWechatSession
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         if (completion) {
             completion(state);
         }
     }];
}

+ (void)shareToWeibo:(PGShareItem *)shareItem completion:(void (^)(SSDKResponseState state))completion
{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    [shareParams SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@ 点击查看:%@", shareItem.text, shareItem.url]
                                               title:shareItem.title
                                               image:shareItem.weiboImage
                                                 url:[NSURL URLWithString:shareItem.url]
                                            latitude:0.f
                                           longitude:0.f
                                            objectID:nil
                                                type:SSDKContentTypeAuto];
    
    [ShareSDK share:SSDKPlatformTypeSinaWeibo
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         if (completion) {
             completion(state);
         }
     }];
}

@end
