//
//  PGGlobalObject.m
//  Penguin
//
//  Created by Jing Dai on 7/11/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGGlobalObject.h"

@interface PGGlobalObject ()

@property (nonatomic, strong, readwrite) PGCache *cache;
@property (nonatomic, strong, readwrite) NSString *userId;
@property (nonatomic, strong, readwrite) NSString *accessToken;

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

- (PGCache *)cache
{
    if (!_cache) {
        _cache = [PGCache cacheWithDatabaseName:@"penguin.db"];
    }
    return _cache;
}

@end
