//
//  PGGlobalObject.h
//  Penguin
//
//  Created by Jing Dai on 7/11/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define PGGlobal [PGGlobalObject sharedInstance]

#import <Foundation/Foundation.h>
#import "PGBaseNavigationController.h"
#import "PGAPIClient.h"
#import "PGCache.h"
#import "PGUser.h"

@interface PGGlobalObject : NSObject

+ (PGGlobalObject *)sharedInstance;

@property (nonatomic, strong) PGBaseNavigationController *rootNavigationController;

@property (nonatomic, strong, readonly) PGAPIClient *apiClient;
@property (nonatomic, strong, readonly) PGCache *cache;
@property (nonatomic, strong, readonly) NSString *userId;
@property (nonatomic, strong, readonly) NSString *accessToken;
@property (nonatomic, strong, readonly) NSString *hostUrl;
@property (nonatomic, assign, readwrite) BOOL hasNewMessage;

- (void)synchronizeUserId:(NSString *)userId;
- (void)synchronizeToken:(NSString *)accessToken;
- (void)synchronizeHostUrl:(NSString *)hostUrl;
- (void)updateTimer;

@end
