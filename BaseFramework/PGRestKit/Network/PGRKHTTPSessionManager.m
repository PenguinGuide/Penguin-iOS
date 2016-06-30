//
//  PGRKHTTPSessionManager.m
//  Penguin
//
//  Created by Jing Dai on 6/30/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGRKHTTPSessionManager.h"
#import "SOCKit.h"

@interface NSString (PGRKValidate)

- (BOOL)isValid;

@end

@implementation NSString (PGRKValidate)

- (BOOL)isValid
{
    return self && (self.length > 0);
}

@end

@implementation PGRKHTTPSessionManager

- (void)makeGetRequest:(void (^)(PGRKRequestConfig *config))configBlock
            completion:(PGRKCompletionBlock)completion
               failure:(PGRKFailureBlock)failure
{
    PGRKRequestConfig *config = [[PGRKRequestConfig alloc] init];
    configBlock(config);
    
    if (config.route.isValid) {
        if (config.pattern) {
            
        } else {
            NSURLSessionDataTask *task = [self GET:config.route
                                        parameters:config.params
                                          progress:nil
                                           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                               
                                           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                               
                                           }];
            [task resume];
        }
    }
}

- (void)registerSerializerWithKeyPath:(NSString *)keyPath task:(NSURLSessionTask *)task
{
    
}

@end
