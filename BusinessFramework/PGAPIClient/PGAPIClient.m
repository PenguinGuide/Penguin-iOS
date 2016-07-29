//
//  PGAPIClient.m
//  Penguin
//
//  Created by Jing Dai on 6/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define PG_API_Result_Success 0
#define PG_API_Result_Failed -1

static const NSString *PGBaseURL = @"www.penguinguide.com";
static const NSTimeInterval DefaultRequestTimeout = 30.0;
static const int DefaultMaxConcurrentConnections = 5;

#import "PGAPIClient.h"
#import <sys/utsname.h>

@interface PGAPIClient ()

@property (nonatomic, strong) PGRKHTTPSessionManager *sessionManager;

@end

@implementation PGAPIClient

+ (id)client
{
    return [[PGAPIClient alloc] initWithTimeout:DefaultRequestTimeout operationCount:DefaultMaxConcurrentConnections];
}

+ (id)clientWithTimeout:(NSTimeInterval)timeout
{
    return [[PGAPIClient alloc] initWithTimeout:timeout operationCount:DefaultMaxConcurrentConnections];
}

+ (id)clientWithOperationCount:(NSInteger)operationCount
{
    return [[PGAPIClient alloc] initWithTimeout:DefaultRequestTimeout operationCount:operationCount];
}

+ (id)clientWithTimeout:(NSTimeInterval)timeout operationCount:(NSInteger)operationCount
{
    return [[PGAPIClient alloc] initWithTimeout:timeout operationCount:operationCount];
}

- (id)initWithTimeout:(NSTimeInterval)timeout operationCount:(NSInteger)operationCount
{
    if (self = [super init]) {
        [self initSessionManager:timeout operationCount:operationCount];
    }
    
    return self;
}

- (void)initSessionManager:(NSTimeInterval)timeout operationCount:(NSInteger)operationCount
{
    self.sessionManager = [PGRKHTTPSessionManager sessionManagerWithBaseURL:@"http://www.penguinguide.com" timeout:timeout operationCount:operationCount];
    
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
    [self.sessionManager addValue:@"" forHTTPHeaderField:@"User-Agent"];
    // accept
    [self.sessionManager addValue:@"application/json" forHTTPHeaderField:@"Accept"];
}

- (void)pg_makeGetRequest:(void (^)(PGRKRequestConfig *config))configBlock
               completion:(PGRKCompletionBlock)completion
                  failure:(PGRKFailureBlock)failure
{
    __block PGRKRequestConfig *clientConfig = [[PGRKRequestConfig alloc] init];
    configBlock(clientConfig);
    
    __weak typeof(self) weakSelf = self;
    [self.sessionManager makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = clientConfig.route;
        config.keyPath = clientConfig.keyPath;
        config.params = clientConfig.params;
        config.model = clientConfig.model;
        config.pattern = clientConfig.pattern;
        config.isMockAPI = clientConfig.isMockAPI;
        config.mockFileName = clientConfig.mockFileName;
        config.mockStatusCode = clientConfig.mockStatusCode;
        config.mockNetworkSpeed = clientConfig.mockNetworkSpeed;
        config.mockResponseTime = clientConfig.mockResponseTime;
        config.mockNoNetworkConnection = clientConfig.mockNoNetworkConnection;
    } completion:^(id response) {
        if ([response isKindOfClass:[NSArray class]]) {
            if (completion) {
                completion(response);
            }
        } else if ([response isKindOfClass:[clientConfig.model class]]) {
            if (completion) {
                completion(@[response]);
            }
        } else {
            [weakSelf handleResponse:response completion:completion failure:failure];
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)handleResponse:(id)response completion:(PGRKCompletionBlock)completion failure:(PGRKFailureBlock)failure
{
    if ([response isKindOfClass:[NSDictionary class]]) {
        NSDictionary *responseDict = (NSDictionary *)response;
        if (responseDict[@"result"]) {
            NSInteger resultCode = [responseDict[@"result"] integerValue];
            
            if (resultCode == PG_API_Result_Success) {
                if (completion) {
                    completion(responseDict);
                }
            } else if (resultCode == PG_API_Result_Failed) {
                
            }
        }
    }
}

- (void)cancelAllRequests
{
    [self.sessionManager cancelAllTasks];
}

@end
