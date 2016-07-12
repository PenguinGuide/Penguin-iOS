//
//  PGRKRequestConfig.h
//  Penguin
//
//  Created by Jing Dai on 6/30/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGRKParams.h"
#import "PGRKModel.h"
#import "PGRKMockAPIManager.h"

@interface PGRKRequestConfig : NSObject

/**
 *  @property route
 *
 *  @brief api route name
 */
@property (nonatomic, strong) NSString *route;

/**
 *  @property keyPath
 *
 *  @brief response key path
 */
@property (nonatomic, strong) NSString *keyPath;

/**
 *  @property params
 *
 *  @brief api parameters
 */
@property (nonatomic, strong) PGRKParams *params;

/**
 *  @property model
 *
 *  @brief response mapping model
 */
@property (nonatomic, strong) PGRKModel *model;

/**
 *  @property pattern
 *
 *  @brief path patterns
           pattern example:
                API: /api/v1/note/:noteId/tag/:tagId
                Pattern:
                NSDictionary *pattern = @{
                    @"noteId" : @"1111111",
                    @"tagId" : @"2222222"
                };
 */
@property (nonatomic, strong) NSDictionary *pattern;

/**
 *  Mock Configs ********* IMPORTANT DEBUG ONLY *********
 */

/**
 *  @property isMockAPI
 *
 *  @brief boolean value indicates call mock data
 */
@property (nonatomic) BOOL isMockAPI;

/**
 *  @property mockFileName
 *
 *  @brief mock file name
 */

@property (nonatomic, strong) NSString *mockFileName;

/**
 *  @property mockStatusCode
 *
 *  @brief mock status code (e.g. 404)
 */
@property (nonatomic) int mockStatusCode;

/**
 *  @property mockNoNetworkConnection
 *
 *  @brief boolean value indicates turn off network connection
 */
@property (nonatomic) BOOL mockNoNetworkConnection;

/**
 *  @property mockResponseTime
 *
 *  @brief mock response time (e.g. 10.5)
 */
@property (nonatomic) NSTimeInterval mockResponseTime;

/**
 *  @property mockNetworkSpeed
 *
 *  @brief mock network speed
 */
@property (nonatomic) MockNetworkSpeed mockNetworkSpeed;

@end
