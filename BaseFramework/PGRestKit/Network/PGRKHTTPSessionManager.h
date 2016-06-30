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
#import "PGRKCompoundResponseSerializer.h"
#import "PGRKRequestConfig.h"

@interface PGRKHTTPSessionManager : AFHTTPSessionManager

@property (nonatomic, strong) PGRKCompoundResponseSerializer *responseSerializer;

- (instancetype)sessionManagerWithBaseURL:(NSString *)baseURL timeout:(NSTimeInterval)timeout;

- (void)makeGetRequest:(void(^)(PGRKRequestConfig *config))configBlock
            completion:(PGRKCompletionBlock)completion
               failure:(PGRKFailureBlock)failure;

@end
