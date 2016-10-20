//
//  PGAPIClient.h
//  Penguin
//
//  Created by Jing Dai on 6/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGRestKit.h"

@interface PGAPIClient : NSObject

+ (id)client;
+ (id)clientWithTimeout:(NSTimeInterval)timeout;
+ (id)clientWithOperationCount:(NSInteger)operationCount;
+ (id)clientWithTimeout:(NSTimeInterval)timeout operationCount:(NSInteger)operationCount;

+ (void)enableLogging;
+ (void)disableLogging;

- (void)updateAccessToken:(NSString *)accessToken;

- (void)pg_makeGetRequest:(void(^)(PGRKRequestConfig *config))configBlock
               completion:(PGRKCompletionBlock)completion
                  failure:(PGRKFailureBlock)failure;

- (void)pg_makePostRequest:(void(^)(PGRKRequestConfig *config))configBlock
                completion:(PGRKCompletionBlock)completion
                   failure:(PGRKFailureBlock)failure;

- (void)pg_makePatchRequest:(void(^)(PGRKRequestConfig *config))configBlock
                 completion:(PGRKCompletionBlock)completion
                    failure:(PGRKFailureBlock)failure;

- (void)cancelAllRequests;

@end
