//
//  PGQiniuUploadImageManager.m
//  Penguin
//
//  Created by Jing Dai on 08/12/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGQiniuUploadImageManager.h"
#import <QiniuSDK.h>

@interface PGQiniuUploadImageManager ()

@end

@implementation PGQiniuUploadImageManager

+ (PGQiniuUploadImageManager *)sharedManager
{
    static PGQiniuUploadImageManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PGQiniuUploadImageManager alloc] init];
    });
    
    return sharedInstance;
}

- (void)uploadImage:(UIImage *)image completion:(void (^)(NSString *url))completion
{
    // https://github.com/qiniu/objc-sdk/issues/218
    if (!image) {
        if (completion) {
            completion(nil);
        }
    } else {
        PGWeakSelf(self);
        [PGGlobal.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
            config.route = PG_Qiniu_Token;
            config.keyPath = nil;
        } completion:^(id response) {
            NSDictionary *responseDict = [response firstObject];
            if (responseDict && [responseDict isKindOfClass:[NSDictionary class]] && responseDict[@"uptoken"] && responseDict[@"domain"]) {
                NSString *token = responseDict[@"uptoken"];
                NSString *domain = responseDict[@"domain"];
                if (token && token.length > 0 && domain && domain.length > 0) {
                    [weakself upload:image token:token domain:domain completion:completion];
                } else {
                    if (completion) {
                        completion(nil);
                    }
                }
            } else {
                if (completion) {
                    completion(nil);
                }
            }
        } failure:^(NSError *error) {
            if (completion) {
                completion(nil);
            }
        }];
    }
}

- (void)upload:(UIImage *)image token:(NSString *)token domain:(NSString *)domain completion:(void (^)(NSString *url))completion
{
    __block NSData *imageData = UIImageJPEGRepresentation(image, 0.9f);
    
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        builder.timeoutInterval = 15.f;
    }];
    QNUploadManager *uploadMgr = [[QNUploadManager alloc] initWithConfiguration:config];
    [uploadMgr putData:imageData key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if (resp[@"hash"] && [resp[@"hash"] length] > 0) {
            NSString *avatarUrl = [NSString stringWithFormat:@"https://%@/%@", domain, resp[@"hash"]];
            if (completion) {
                completion(avatarUrl);
            }
        } else {
            if (completion) {
                completion(nil);
            }
        }
    } option:nil];
}

@end
