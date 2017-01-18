//
//  PGAPIClient.m
//  Penguin
//
//  Created by Jing Dai on 6/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define PG_API_Result_Success 0
#define PG_API_Result_Failed -1

static const NSTimeInterval DefaultRequestTimeout = 30.0;
static const int DefaultMaxConcurrentConnections = 5;

#import "PGAPIClient.h"
#import <sys/utsname.h>

@interface PGAPIClient ()

@property (nonatomic, strong) PGRKHTTPSessionManager *sessionManager;

@end

@implementation PGAPIClient

#pragma mark - <Init Methods>

+ (id)clientWithBaseUrl:(NSString *)baseUrl
{
    return [[PGAPIClient alloc] initWithBaseUrl:baseUrl timeout:DefaultRequestTimeout operationCount:DefaultMaxConcurrentConnections];
}

+ (id)clientWithBaseUrl:(NSString *)baseUrl timeout:(NSTimeInterval)timeout
{
    return [[PGAPIClient alloc] initWithBaseUrl:baseUrl timeout:timeout operationCount:DefaultMaxConcurrentConnections];
}

+ (id)clientWithBaseUrl:(NSString *)baseUrl operationCount:(NSInteger)operationCount
{
    return [[PGAPIClient alloc] initWithBaseUrl:baseUrl timeout:DefaultRequestTimeout operationCount:operationCount];
}

+ (id)clientWithBaseUrl:(NSString *)baseUrl timeout:(NSTimeInterval)timeout operationCount:(NSInteger)operationCount
{
    return [[PGAPIClient alloc] initWithBaseUrl:baseUrl timeout:timeout operationCount:operationCount];
}

- (id)initWithBaseUrl:(NSString *)baseUrl timeout:(NSTimeInterval)timeout operationCount:(NSInteger)operationCount
{
    if (self = [super init]) {
        [self initSessionManager:baseUrl timeout:timeout operationCount:operationCount];
    }
    
    return self;
}

- (void)initSessionManager:(NSString *)baseUrl timeout:(NSTimeInterval)timeout operationCount:(NSInteger)operationCount
{
    if (baseUrl && baseUrl.length > 0) {
        self.sessionManager = [PGRKHTTPSessionManager sessionManagerWithBaseURL:baseUrl timeout:timeout operationCount:operationCount];
    }
    
    // content-type
    [self.sessionManager addAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/css", @"text/plain", nil]];
    
    // device info
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceInfo = [NSString stringWithCString:systemInfo.machine
                                              encoding:NSUTF8StringEncoding];
    // device resolution
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGSize screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
    // app version number
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    // app build number
    NSString *appBuild = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
    // user-agent
    NSString *userAgent = [self.sessionManager.requestSerializer valueForHTTPHeaderField:@"User-Agent"];
    userAgent = [userAgent stringByAppendingString:[NSString stringWithFormat:@" Resolution/%@ Device/%@ Version/%@ Build/%@", [NSString stringWithFormat:@"%d*%d", (NSInteger)screenSize.width, (NSInteger)screenSize.height], deviceInfo, appVersion, appBuild]];
    [self.sessionManager addValue:userAgent forHTTPHeaderField:@"User-Agent"];
    // accept
    [self.sessionManager addValue:@"application/json" forHTTPHeaderField:@"Accept"];
}

#pragma mark - <Authorization Header Field>

- (void)setAuthorizationHeaderField:(NSString *)token
{
    if (token && token.length > 0) {
        [self.sessionManager addValue:token forHTTPHeaderField:@"Authorization"];
    } else {
        [self.sessionManager.requestSerializer clearAuthorizationHeader];
    }
    
}

- (void)clearAuthorizationHeader
{
    [self.sessionManager.requestSerializer clearAuthorizationHeader];
}

#pragma mark - <Base Url>

- (void)setBaseUrl:(NSString *)baseUrl
{
    [self cancelAllRequests];
    [self initSessionManager:baseUrl timeout:DefaultRequestTimeout operationCount:DefaultMaxConcurrentConnections];
}

#pragma mark - <Request Logger>

+ (void)enableLogging
{
    [PGRKHTTPSessionManager enableLogging];
}

+ (void)disableLogging
{
    [PGRKHTTPSessionManager disableLogging];
}

#pragma mark - <Request Methods>

- (void)pg_makeGetRequest:(void (^)(PGRKRequestConfig *config))configBlock
               completion:(PGRKCompletionBlock)completion
                  failure:(PGRKFailureBlock)failure
{
    __block PGRKRequestConfig *clientConfig = [[PGRKRequestConfig alloc] init];
    configBlock(clientConfig);
    
    __weak typeof(self) weakSelf = self;
    [self.sessionManager makeGetRequest:configBlock
                             completion:^(id response) {
                                 if ([response isKindOfClass:[NSArray class]]) {
                                     if (completion) {
                                         completion(response);
                                     }
                                 } else if ([response isKindOfClass:[clientConfig.model class]]) {
                                     if (completion) {
                                         completion(@[response]);
                                     }
                                 } else {
                                     if (completion) {
                                         completion(@[response]);
                                     }
                                 }
                                 [[NSNotificationCenter defaultCenter] postNotificationName:PG_REQUEST_SUCCESS_NOTIFICATION object:nil];
                             } failure:^(NSError *error) {
                                 if (failure) {
                                     failure(error);
                                 }
                             }];
}

- (void)pg_makeGetRequest:(void (^)(PGRKRequestConfig *config))configBlock
     paginationCompletion:(PGRKPaginationCompletionBlock)completion
                  failure:(PGRKFailureBlock)failure
{
    __block PGRKRequestConfig *clientConfig = [[PGRKRequestConfig alloc] init];
    configBlock(clientConfig);
    
    __weak typeof(self) weakSelf = self;
    [self.sessionManager makeGetRequest:configBlock
                   paginationCompletion:^(PGRKResponse *response) {
                       if (completion) {
                           completion(response);
                       }
                       [[NSNotificationCenter defaultCenter] postNotificationName:PG_REQUEST_SUCCESS_NOTIFICATION object:nil];
                   } failure:^(NSError *error) {
                       if (failure) {
                           failure(error);
                       }
                   }];
}

- (void)pg_makePutRequest:(void (^)(PGRKRequestConfig *config))configBlock
               completion:(PGRKCompletionBlock)completion
                  failure:(PGRKFailureBlock)failure
{
    __block PGRKRequestConfig *clientConfig = [[PGRKRequestConfig alloc] init];
    configBlock(clientConfig);
    
    __weak typeof(self) weakSelf = self;
    [self.sessionManager makePutRequest:configBlock
                             completion:^(id response) {
                                 if (completion) {
                                     completion(response);
                                 }
                                 [[NSNotificationCenter defaultCenter] postNotificationName:PG_REQUEST_SUCCESS_NOTIFICATION object:nil];
                             } failure:^(NSError *error) {
                                 if (failure) {
                                     failure(error);
                                 }
                             }];
}

- (void)pg_makePostRequest:(void (^)(PGRKRequestConfig *))configBlock
                completion:(PGRKCompletionBlock)completion
                   failure:(PGRKFailureBlock)failure
{
    __block PGRKRequestConfig *clientConfig = [[PGRKRequestConfig alloc] init];
    configBlock(clientConfig);
    
    [self.sessionManager makePostRequest:configBlock
                              completion:^(id response) {
                                  if (completion) {
                                      completion(response);
                                  }
                                  [[NSNotificationCenter defaultCenter] postNotificationName:PG_REQUEST_SUCCESS_NOTIFICATION object:nil];
                              } failure:^(NSError *error) {
                                  if (failure) {
                                      failure(error);
                                  }
                              }];
}

- (void)pg_makePatchRequest:(void (^)(PGRKRequestConfig *))configBlock
                 completion:(PGRKCompletionBlock)completion
                    failure:(PGRKFailureBlock)failure
{
    __block PGRKRequestConfig *clientConfig = [[PGRKRequestConfig alloc] init];
    configBlock(clientConfig);
    
    [self.sessionManager makePatchRequest:configBlock
                               completion:^(id response) {
                                   if (completion) {
                                       completion(response);
                                   }
                                   [[NSNotificationCenter defaultCenter] postNotificationName:PG_REQUEST_SUCCESS_NOTIFICATION object:nil];
                               } failure:^(NSError *error) {
                                   if (failure) {
                                       failure(error);
                                   }
                               }];
}

- (void)pg_makeDeleteRequest:(void (^)(PGRKRequestConfig *config))configBlock
                  completion:(PGRKCompletionBlock)completion
                     failure:(PGRKFailureBlock)failure
{
    __block PGRKRequestConfig *clientConfig = [[PGRKRequestConfig alloc] init];
    configBlock(clientConfig);
    
    [self.sessionManager makeDeleteRequest:configBlock
                                completion:^(id response) {
                                    if (completion) {
                                        completion(response);
                                    }
                                    [[NSNotificationCenter defaultCenter] postNotificationName:PG_REQUEST_SUCCESS_NOTIFICATION object:nil];
                                } failure:^(NSError *error) {
                                    if (failure) {
                                        failure(error);
                                    }
                                }];
}

- (void)pg_uploadImage:(void (^)(PGRKRequestConfig *))configBlock
            completion:(PGRKCompletionBlock)completion
               failure:(PGRKFailureBlock)failure
{
    __block PGRKRequestConfig *clientConfig = [[PGRKRequestConfig alloc] init];
    configBlock(clientConfig);
    
    [self.sessionManager makeUploadImage:configBlock
                              completion:^(id response) {
                                  if (completion) {
                                      completion(response);
                                  }
                                  [[NSNotificationCenter defaultCenter] postNotificationName:PG_REQUEST_SUCCESS_NOTIFICATION object:nil];
                              } failure:^(NSError *error) {
                                  if (failure) {
                                      failure(error);
                                  }
                              }];
}

- (void)cancelAllRequests
{
    [self.sessionManager cancelAllTasks];
}

@end
