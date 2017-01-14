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

+ (id)clientWithBaseUrl:(NSString *)baseUrl;
+ (id)clientWithBaseUrl:(NSString *)baseUrl timeout:(NSTimeInterval)timeout;
+ (id)clientWithBaseUrl:(NSString *)baseUrl operationCount:(NSInteger)operationCount;
+ (id)clientWithBaseUrl:(NSString *)baseUrl timeout:(NSTimeInterval)timeout operationCount:(NSInteger)operationCount;

- (void)setAuthorizationHeaderField:(NSString *)token;
- (void)clearAuthorizationHeader;
- (void)setBaseUrl:(NSString *)baseUrl;

+ (void)enableLogging;
+ (void)disableLogging;

- (void)pg_makeGetRequest:(void(^)(PGRKRequestConfig *config))configBlock
               completion:(PGRKCompletionBlock)completion
                  failure:(PGRKFailureBlock)failure;

- (void)pg_makeGetRequest:(void(^)(PGRKRequestConfig *config))configBlock
     paginationCompletion:(PGRKPaginationCompletionBlock)completion
                  failure:(PGRKFailureBlock)failure;

- (void)pg_makePutRequest:(void(^)(PGRKRequestConfig *config))configBlock
               completion:(PGRKCompletionBlock)completion
                  failure:(PGRKFailureBlock)failure;

- (void)pg_makePostRequest:(void(^)(PGRKRequestConfig *config))configBlock
                completion:(PGRKCompletionBlock)completion
                   failure:(PGRKFailureBlock)failure;

- (void)pg_makePatchRequest:(void(^)(PGRKRequestConfig *config))configBlock
                 completion:(PGRKCompletionBlock)completion
                    failure:(PGRKFailureBlock)failure;

- (void)pg_makeDeleteRequest:(void(^)(PGRKRequestConfig *config))configBlock
                  completion:(PGRKCompletionBlock)completion
                     failure:(PGRKFailureBlock)failure;

- (void)pg_uploadImage:(void(^)(PGRKRequestConfig *config))configBlock
            completion:(PGRKCompletionBlock)completion
               failure:(PGRKFailureBlock)failure;

- (void)cancelAllRequests;

@end
