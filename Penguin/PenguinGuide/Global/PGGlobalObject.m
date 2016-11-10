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

@property (nonatomic, strong, readwrite) MSWeakTimer *weakTimer;

@end

@implementation PGGlobalObject

+ (PGGlobalObject *)sharedInstance
{
    static PGGlobalObject *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PGGlobalObject alloc] init];
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
    } else {
        [self.cache deleteObjectForKey:@"access_token" fromTable:@"Session"];
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

#pragma mark - <Setters && Getters>

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
        _apiClient = [PGAPIClient client];
        [_apiClient updateAccessToken:[NSString stringWithFormat:@"Bearer %@", self.accessToken]];
    }
    return _apiClient;
}

@end
