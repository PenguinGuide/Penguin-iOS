//
//  PGShareManager.m
//  Pods
//
//  Created by Jing Dai on 6/27/16.
//
//

static const NSString *sdkKey = @"145aaacfc8950";

#import "PGShareManager.h"

@implementation PGShareManager

+ (void)registerShareSDK
{
    [ShareSDK registerApp:sdkKey
          activePlatforms:@[@(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformTypeSinaWeibo)]
                 onImport:^(SSDKPlatformType platformType) {
                     switch (platformType) {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
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
                             [appInfo SSDKSetupWeChatByAppId:@""
                                                   appSecret:@""];
                             break;
                         case SSDKPlatformTypeQQ:
                             [appInfo SSDKSetupQQByAppId:@""
                                                  appKey:@""
                                                authType:SSDKAuthTypeBoth];
                             break;
                         case SSDKPlatformTypeSinaWeibo:
                             [appInfo SSDKSetupSinaWeiboByAppKey:@""
                                                       appSecret:@""
                                                     redirectUri:@"http://www.sharesdk.cn"
                                                        authType:SSDKAuthTypeBoth];
                         default:
                             break;
                     }
                 }];
}

+ (void)shareItem:(void (^)(PGShareItem *shareItem))itemBlock toPlatform:(SSDKPlatformType)platformType completion:(void (^)(BOOL))completion
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
        case SSDKPlatformTypeQQ:
            [PGShareManager shareToQQ:shareItem completion:completion];
            break;
        default:
            break;
    }
}

+ (void)shareToWechatTimeline:(PGShareItem *)shareItem completion:(void (^)(BOOL))completion
{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    [shareParams SSDKSetupWeChatParamsByText:shareItem.text
                                       title:shareItem.title
                                         url:shareItem.url
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
         
     }];
}

+ (void)shareToWechatSession:(PGShareItem *)shareItem completion:(void (^)(BOOL))completion
{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    [shareParams SSDKSetupWeChatParamsByText:shareItem.text
                                       title:shareItem.title
                                         url:shareItem.url
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
         
     }];
}

+ (void)shareToWeibo:(PGShareItem *)shareItem completion:(void (^)(BOOL))completion
{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    [shareParams SSDKSetupSinaWeiboShareParamsByText:shareItem.text
                                               title:shareItem.title
                                               image:shareItem.image
                                                 url:shareItem.url
                                            latitude:0.f
                                           longitude:0.f
                                            objectID:nil
                                                type:SSDKContentTypeWebPage];
    
    [ShareSDK share:SSDKPlatformTypeSinaWeibo
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         
     }];
}

+ (void)shareToQQ:(PGShareItem *)shareItem completion:(void (^)(BOOL))completion
{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    [shareParams SSDKSetupQQParamsByText:shareItem.text
                                   title:shareItem.title
                                     url:shareItem.url
                              thumbImage:shareItem.thumbnailImage
                                   image:shareItem.image
                                    type:SSDKContentTypeWebPage
                      forPlatformSubType:SSDKPlatformSubTypeQQFriend];
    
    [ShareSDK share:SSDKPlatformTypeQQ
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         
     }];
}

@end
