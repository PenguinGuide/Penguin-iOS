//
//  PGRKHTTPSessionManager.m
//  Penguin
//
//  Created by Jing Dai on 6/30/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

static const NSTimeInterval DefaultRequestTimeout = 30.0;
static const int DefaultMaxConcurrentConnections = 5;

#import "PGRKHTTPSessionManager.h"
#import "SOCKit.h"
#import "PGRKMockAPIManager.h"
#import "PGRKNetworkLogger.h"
#import "PGRKPagination.h"

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

+ (id)sessionManagerWithBaseURL:(NSString *)baseURL
{
    return [PGRKHTTPSessionManager sessionManagerWithBaseURL:baseURL timeout:DefaultRequestTimeout operationCount:DefaultMaxConcurrentConnections];
}

+ (id)sessionManagerWithBaseURL:(NSString *)baseURL timeout:(NSTimeInterval)timeout
{
    return [PGRKHTTPSessionManager sessionManagerWithBaseURL:baseURL timeout:timeout operationCount:DefaultMaxConcurrentConnections];
}

+ (id)sessionManagerWithBaseURL:(NSString *)baseURL operationCount:(NSInteger)operationCount
{
    return [PGRKHTTPSessionManager sessionManagerWithBaseURL:baseURL timeout:DefaultRequestTimeout operationCount:operationCount];
}

+ (id)sessionManagerWithBaseURL:(NSString *)baseURL timeout:(NSTimeInterval)timeout operationCount:(NSInteger)operationCount
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = timeout;
    config.HTTPMaximumConnectionsPerHost = operationCount;
    config.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    PGRKHTTPSessionManager *sessionManager = [[PGRKHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]
                                                                        sessionConfiguration:config];
    sessionManager.responseSerializer = [PGRKJSONResponseSerializer serializer];
    return sessionManager;
}

+ (void)enableLogging
{
    [[PGRKNetworkLogger sharedInstance] startLogging];
}

+ (void)disableLogging
{
    [[PGRKNetworkLogger sharedInstance] stopLogging];
}

- (void)addAcceptableContentTypes:(NSSet *)contentTypes
{
    [self.responseSerializer setAcceptableContentTypes:contentTypes];
}

- (void)addValue:(NSString *)value forHTTPHeaderField:(NSString *)field
{
    [self.requestSerializer setValue:value forHTTPHeaderField:field];
}

- (void)makeGetRequest:(void (^)(PGRKRequestConfig *config))configBlock
            completion:(PGRKCompletionBlock)completion
               failure:(PGRKFailureBlock)failure
{
    PGRKRequestConfig *config = [[PGRKRequestConfig alloc] init];
    configBlock(config);
 
#if (defined ADHOC) || (defined DEBUG)
    __block id<OHHTTPStubsDescriptor> stub = nil;
    if (config.isMockAPI) {
        if (config.mockFileName && config.mockFileName.length > 0) {
            if (config.mockStatusCode != 200 && config.mockStatusCode != 0) {
                NSString *patternedRoute = config.route;
                if (config.pattern) {
                    NSString *finalRoute = SOCStringFromStringWithDictionary(config.route, config.pattern);
                    if (finalRoute) {
                        patternedRoute = finalRoute;
                    }
                }
                stub = [PGRKMockAPIManager mockAPI:patternedRoute fileName:config.mockFileName statusCode:config.mockStatusCode];
            } else if (config.mockResponseTime > 0) {
                NSString *patternedRoute = config.route;
                if (config.pattern) {
                    NSString *finalRoute = SOCStringFromStringWithDictionary(config.route, config.pattern);
                    if (finalRoute) {
                        patternedRoute = finalRoute;
                    }
                }
                stub = [PGRKMockAPIManager mockAPI:patternedRoute fileName:config.mockFileName responseTime:config.mockResponseTime];
            } else if (config.mockNoNetworkConnection) {
                NSString *patternedRoute = config.route;
                if (config.pattern) {
                    NSString *finalRoute = SOCStringFromStringWithDictionary(config.route, config.pattern);
                    if (finalRoute) {
                        patternedRoute = finalRoute;
                    }
                }
                stub = [PGRKMockAPIManager mockNoInternetAPI:patternedRoute];
            } else {
                NSString *patternedRoute = config.route;
                if (config.pattern) {
                    NSString *finalRoute = SOCStringFromStringWithDictionary(config.route, config.pattern);
                    if (finalRoute) {
                        patternedRoute = finalRoute;
                    }
                }
                stub = [PGRKMockAPIManager mockAPI:patternedRoute fileName:config.mockFileName];
            }
        }
    }
    if (config.route.isValid) {
        NSString *finalRoute = config.route;
        if (config.pattern) {
            NSString *route = SOCStringFromStringWithDictionary(config.route, config.pattern);
            finalRoute = route ? route : config.route;
        }
        if (config.model) {
            NSURLSessionDataTask *task = [self GET:finalRoute
                                        parameters:config.params
                                          progress:nil
                                           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                               [PGRKMockAPIManager clearMockStub:stub];
                                               if (completion) {
                                                   completion(responseObject);
                                               }
                                           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                               [PGRKMockAPIManager clearMockStub:stub];
                                               if (failure) {
                                                   failure(error);
                                               }
                                           }];
            PGRKJSONResponseSerializer *serializer = self.responseSerializer;
            [serializer registerKeyPath:config.keyPath modelClass:config.model.class toTask:task];
        } else {
            [self GET:finalRoute
           parameters:config.params
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  [PGRKMockAPIManager clearMockStub:stub];
                  if (completion) {
                      completion(responseObject);
                  }
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  [PGRKMockAPIManager clearMockStub:stub];
                  if (failure) {
                      failure(error);
                  }
              }];
        }
    }
#else
    if (config.route.isValid) {
        NSString *finalRoute = config.route;
        if (config.pattern) {
            NSString *route = SOCStringFromStringWithDictionary(config.route, config.pattern);
            finalRoute = route ? route : config.route;
        }
        if (config.model) {
            NSURLSessionDataTask *task = [self GET:finalRoute
                                        parameters:config.params
                                          progress:nil
                                           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                               if (completion) {
                                                   completion(responseObject);
                                               }
                                           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                               if (failure) {
                                                   failure(error);
                                               }
                                           }];
            PGRKJSONResponseSerializer *serializer = self.responseSerializer;
            [serializer registerKeyPath:config.keyPath modelClass:config.model.class toTask:task];
        } else {
            [self GET:finalRoute
           parameters:config.params
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  if (completion) {
                      completion(responseObject);
                  }
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  if (failure) {
                      failure(error);
                  }
              }];
        }
    }
#endif
}

- (void)makeGetRequest:(void (^)(PGRKRequestConfig *config))configBlock
  paginationCompletion:(PGRKPaginationCompletionBlock)completion
               failure:(PGRKFailureBlock)failure
{
    __block PGRKRequestConfig *config = [[PGRKRequestConfig alloc] init];
    configBlock(config);
    
    if (config.route.isValid) {
        NSString *finalRoute;
        if ([config.response.pagination.cursor containsString:@"http://"] || [config.response.pagination.cursor containsString:@"https://"]) {
            config.route = config.response.pagination.cursor;
            config.params = nil;
            finalRoute = config.response.pagination.cursor;
        } else {
            finalRoute = config.route;
            if (config.pattern) {
                NSString *route = SOCStringFromStringWithDictionary(config.route, config.pattern);
                finalRoute = route ? route : config.route;
            }
        }
        if (config.model || config.models) {
            NSURLSessionDataTask *task = [self GET:finalRoute
                                        parameters:config.params
                                          progress:nil
                                           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                               if (completion) {
                                                   if ([responseObject isKindOfClass:[PGRKResponse class]]) {
                                                       completion(responseObject);
                                                   } else {
                                                       completion(nil);
                                                   }
                                               }
                                           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                               if (failure) {
                                                   failure(error);
                                               }
                                           }];
            
            PGRKJSONResponseSerializer *serializer = self.responseSerializer;
            if (config.response) {
                if (config.model) {
                    [serializer registerKeyPath:config.keyPath modelClass:config.model.class toTask:task response:config.response];
                } else if (config.models) {
                    [serializer registerKeyPath:config.keyPath modelClasses:config.models typeKey:config.typeKey toTask:task response:config.response];
                } else {
                    if (failure) {
                        failure(nil);
                    }
                }
            } else {
                if (failure) {
                    failure(nil);
                }
            }
        } else {
            [self GET:finalRoute
           parameters:config.params
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  if (completion) {
                      completion(responseObject);
                  }
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  if (failure) {
                      failure(error);
                  }
              }];
        }
    }
}

- (void)makePutRequest:(void (^)(PGRKRequestConfig *config))configBlock
            completion:(PGRKCompletionBlock)completion
               failure:(PGRKFailureBlock)failure
{
    PGRKRequestConfig *config = [[PGRKRequestConfig alloc] init];
    configBlock(config);
    
    if (config.route.isValid) {
        NSString *finalRoute = config.route;
        if (config.pattern) {
            NSString *route = SOCStringFromStringWithDictionary(config.route, config.pattern);
            finalRoute = route ? route : config.route;
        }
        if (config.model) {
            NSURLSessionDataTask *task = [self PUT:finalRoute
                                        parameters:config.params
                                           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                               if (completion) {
                                                   completion(responseObject);
                                               }
                                           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                               if (failure) {
                                                   failure(error);
                                               }
                                           }];
            PGRKJSONResponseSerializer *serializer = self.responseSerializer;
            [serializer registerKeyPath:config.keyPath modelClass:config.model.class toTask:task];
        } else {
            [self PUT:finalRoute
           parameters:config.params
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  if (completion) {
                      completion(responseObject);
                  }
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  if (failure) {
                      failure(error);
                  }
              }];
        }
    }
}

- (void)makePostRequest:(void (^)(PGRKRequestConfig *config))configBlock
             completion:(PGRKCompletionBlock)completion
                failure:(PGRKFailureBlock)failure
{
    PGRKRequestConfig *config = [[PGRKRequestConfig alloc] init];
    configBlock(config);
    
    if (config.route.isValid) {
        NSString *finalRoute = config.route;
        if (config.pattern) {
            NSString *route = SOCStringFromStringWithDictionary(config.route, config.pattern);
            finalRoute = route ? route : config.route;
        }
        
        [self POST:finalRoute
        parameters:config.params
          progress:nil
           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               if (completion) {
                   completion(responseObject);
               }
           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               if (failure) {
                   failure(error);
               }
           }];
    }
}

- (void)makePatchRequest:(void (^)(PGRKRequestConfig *))configBlock
              completion:(PGRKCompletionBlock)completion
                 failure:(PGRKFailureBlock)failure
{
    PGRKRequestConfig *config = [[PGRKRequestConfig alloc] init];
    configBlock(config);
    
    if (config.route.isValid) {
        NSString *finalRoute = config.route;
        if (config.pattern) {
            NSString *route = SOCStringFromStringWithDictionary(config.route, config.pattern);
            finalRoute = route ? route : config.route;
        }
        
        [self PATCH:finalRoute
         parameters:config.params
            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (completion) {
                    completion(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
    }
}

- (void)makeDeleteRequest:(void (^)(PGRKRequestConfig *config))configBlock
               completion:(PGRKCompletionBlock)completion
                  failure:(PGRKFailureBlock)failure
{
    PGRKRequestConfig *config = [[PGRKRequestConfig alloc] init];
    configBlock(config);
    
    if (config.route.isValid) {
        NSString *finalRoute = config.route;
        if (config.pattern) {
            NSString *route = SOCStringFromStringWithDictionary(config.route, config.pattern);
            finalRoute = route ? route : config.route;
        }
        
        [self DELETE:finalRoute
          parameters:config.params
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 if (completion) {
                     completion(responseObject);
                 }
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 if (failure) {
                     failure(error);
                 }
             }];
    }
}

- (void)makeUploadImage:(void (^)(PGRKRequestConfig *config))configBlock
             completion:(PGRKCompletionBlock)completion
                failure:(PGRKFailureBlock)failure
{
    PGRKRequestConfig *config = [[PGRKRequestConfig alloc] init];
    configBlock(config);
    
    __block NSData *imageData = UIImageJPEGRepresentation(config.image, 0.9f);
    
    // http://blog.csdn.net/a645258072/article/details/51728806
    NSString *mimeType = @"image/jpeg";
    NSString *finalStr = [NSString stringWithFormat:@"data:%@;base64,%@", mimeType, [imageData base64EncodedStringWithOptions:0]];
    
    if (!config.params) {
        config.params = [PGRKParams new];
        config.params[@"image_data"] = finalStr;
    } else {
        config.params[@"image_data"] = finalStr;
    }
    
    [self POST:config.route
    parameters:config.params
      progress:^(NSProgress * _Nonnull uploadProgress) {
          NSLog(@"-------- percentage: %@", @(uploadProgress.fractionCompleted));
      } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          if (completion) {
              completion(responseObject);
          }
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          if (failure) {
              failure(error);
          }
      }];
}

- (void)cancelAllTasks
{
    [self.tasks enumerateObjectsUsingBlock:^(NSURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
        [task cancel];
    }];
}

@end
