//
//  PGGlobalObject.m
//  Penguin
//
//  Created by Jing Dai on 7/11/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGGlobalObject.h"
#import "MSWeakTimer.h"

@interface PGGlobalObject ()

@property (nonatomic, strong, readwrite) PGAPIClient *apiClient;
@property (nonatomic, strong, readwrite) PGCache *cache;
@property (nonatomic, strong, readwrite) NSString *userId;
@property (nonatomic, strong, readwrite) NSString *accessToken;
@property (nonatomic, strong, readwrite) NSString *hostUrl;

@property (nonatomic, strong, readwrite) MSWeakTimer *weakTimer;
@property (nonatomic, strong, readwrite) MSWeakTimer *smsCodeTimer;

@end

@implementation PGGlobalObject

+ (PGGlobalObject *)sharedInstance
{
    static PGGlobalObject *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    if (self = [super init]) {
        NSArray *accessTokenObject = [self.cache objectForKey:@"access_token" fromTable:@"Session"];
        if (accessTokenObject && [accessTokenObject isKindOfClass:[NSArray class]]) {
            self.accessToken = [accessTokenObject firstObject];
        } else {
            self.accessToken = nil;
        }
        
        NSArray *userIdObject = [self.cache objectForKey:@"user_id" fromTable:@"Session"];
        if (userIdObject && [userIdObject isKindOfClass:[NSArray class]]) {
            self.userId = [userIdObject firstObject];
        } else {
            self.userId = nil;
        }
        
        if (!self.accessToken || !self.userId) {
            [self synchronizeUserId:nil];
            [self synchronizeToken:nil];
        }
        
        NSArray *hostUrlObject = [self.cache objectForKey:@"host_url" fromTable:@"Session"];
        if (hostUrlObject && [hostUrlObject isKindOfClass:[NSArray class]]) {
            self.hostUrl = [hostUrlObject firstObject];
        } else {
            [self synchronizeHostUrl:@"https://api.penguinguide.cn"];
        }
        
        self.weakTimer = [MSWeakTimer scheduledTimerWithTimeInterval:1*60
                                                              target:self
                                                            selector:@selector(timerDidUpdate)
                                                            userInfo:nil
                                                             repeats:YES
                                                       dispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    }
    return self;
}

- (void)synchronizeUserId:(NSString *)userId
{
    self.userId = userId;
    if (userId) {
        [self.cache putObject:@[self.userId] forKey:@"user_id" intoTable:@"Session"];
    } else {
        [self.cache deleteObjectForKey:@"user_id" fromTable:@"Session"];
    }
}

- (void)synchronizeToken:(NSString *)accessToken
{
    self.accessToken = accessToken;
    if (accessToken) {
        [self.cache putObject:@[self.accessToken] forKey:@"access_token" intoTable:@"Session"];
        [self.apiClient setAuthorizationHeaderField:[NSString stringWithFormat:@"Bearer %@", self.accessToken]];
    } else {
        [self.cache deleteObjectForKey:@"access_token" fromTable:@"Session"];
        [self.apiClient clearAuthorizationHeader];
    }
}

- (void)synchronizeHostUrl:(NSString *)hostUrl
{
    self.hostUrl = hostUrl;
    if (hostUrl) {
        [self.cache putObject:@[self.hostUrl] forKey:@"host_url" intoTable:@"Session"];
        [self.apiClient setBaseUrl:self.hostUrl];
    }
}

- (void)timerDidUpdate
{
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive && PGGlobal.userId && PGGlobal.userId.length > 0) {
        PGWeakSelf(self);
        [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
            config.route = PG_Message_Has_New;
            config.keyPath = nil;
        } completion:^(id response) {
            NSDictionary *responseDict = [response firstObject];
            if (responseDict[@"has_new_message"]) {
                weakself.hasNewMessage = [responseDict[@"has_new_message"] boolValue];
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                if (weakself.hasNewMessage) {
                    [appDelegate.tabBarController showTabDot:3];
                } else {
                    [appDelegate.tabBarController hideTabDot:3];
                }
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)updateTimer
{
    [self timerDidUpdate];
}

- (void)resetSMSCodeTimer
{
    [self.smsCodeTimer invalidate];
    
    self.smsCodeCountDown = 60;
    self.smsCodeTimer = [MSWeakTimer scheduledTimerWithTimeInterval:1.f
                                                             target:self
                                                           selector:@selector(smsCodeTimerUpdate)
                                                           userInfo:nil
                                                            repeats:YES
                                                      dispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

- (void)smsCodeTimerUpdate
{
    if (self.smsCodeCountDown <= 0) {
        [self.smsCodeTimer invalidate];
        self.smsCodeCountDown = 0;
    } else {
        self.smsCodeCountDown--;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:PG_NOTIFICATION_SMS_CODE_COUNT_DOWN object:@(self.smsCodeCountDown)];
}

- (void)registerAPNSToken:(NSString *)token
{
    if (token && token.length > 0) {
        PGParams *params = [PGParams new];
        params[@"device_token"] = token;
        
        [self.apiClient pg_makePostRequest:^(PGRKRequestConfig *config) {
            config.route = PG_Register_APNS_Token;
            config.params = params;
            config.keyPath = nil;
        } completion:^(id response) {
            NSLog(@"APNS register successfully");
        } failure:^(NSError *error) {
            NSLog(@"APNS register failed");
        }];
    }
}

#pragma mark - <Lazy Init>

- (PGCache *)cache
{
    if (!_cache) {
        _cache = [PGCache cacheWithDatabaseName:@"penguin.db"];
    }
    return _cache;
}

- (PGAPIClient *)apiClient
{
    if (!_apiClient) {
        _apiClient = [PGAPIClient clientWithBaseUrl:self.hostUrl];
        if (self.accessToken) {
            [_apiClient setAuthorizationHeaderField:[NSString stringWithFormat:@"Bearer %@", self.accessToken]];
        } else {
            [_apiClient clearAuthorizationHeader];
        }
        
    }
    return _apiClient;
}

@end
