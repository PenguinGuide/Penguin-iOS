//
//  PGRKHTTPSessionManager.h
//  Penguin
//
//  Created by Jing Dai on 6/30/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

typedef void(^PGRKCompletionBlock)(id response);
typedef void(^PGRKFailureBlock)(NSError *error);

#import <AFNetworking/AFNetworking.h>
#import "PGRKJSONResponseSerializer.h"
#import "PGRKRequestConfig.h"

@interface PGRKHTTPSessionManager : AFHTTPSessionManager

+ (id)sessionManagerWithBaseURL:(NSString *)baseURL;
+ (id)sessionManagerWithBaseURL:(NSString *)baseURL timeout:(NSTimeInterval)timeout;
+ (id)sessionManagerWithBaseURL:(NSString *)baseURL operationCount:(NSInteger)operationCount;
+ (id)sessionManagerWithBaseURL:(NSString *)baseURL timeout:(NSTimeInterval)timeout operationCount:(NSInteger)operationCount;

+ (void)enableLogging;
+ (void)disableLogging;

- (void)addAcceptableContentTypes:(NSSet *)contentTypes;
- (void)addValue:(NSString *)value forHTTPHeaderField:(nonnull NSString *)field;

- (void)makeGetRequest:(void(^)(PGRKRequestConfig *config))configBlock
            completion:(PGRKCompletionBlock)completion
               failure:(PGRKFailureBlock)failure;

- (void)makePutRequest:(void(^)(PGRKRequestConfig *config))configBlock
            completion:(PGRKCompletionBlock)completion
               failure:(PGRKFailureBlock)failure;

- (void)makePostRequest:(void(^)(PGRKRequestConfig *config))configBlock
             completion:(PGRKCompletionBlock)completion
                failure:(PGRKFailureBlock)failure;

- (void)makeDeleteRequest:(void(^)(PGRKRequestConfig *config))configBlock
               completion:(PGRKCompletionBlock)completion
                  failure:(PGRKFailureBlock)failure;

- (void)cancelAllTasks;

@end
