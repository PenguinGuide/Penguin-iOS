//
//  PGRKMockAPIManager.h
//  Penguin
//
//  Created by Jing Dai on 7/12/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

typedef NS_ENUM(NSInteger, MockNetworkSpeed) {
    MockDownloadSpeedSlow,  // 1.5 kbps
    MockDownloadSpeedGPRS,  // 7 kbps
    MockDownloadSpeedEDGE,  // 16 kbps
    MockDownloadSpeed3G,    // 400 kbps
    MockDownloadSpeed4G,    // 900 kbps
    MockDownloadSpeedWifi,  // 1500 kbps
};

#import <Foundation/Foundation.h>
#import "OHHTTPStubs.h"

@interface PGRKMockAPIManager : NSObject

+ (id<OHHTTPStubsDescriptor>)mockAPI:(NSString *)route fileName:(NSString *)name;

+ (id<OHHTTPStubsDescriptor>)mockAPI:(NSString *)route jsonDict:(NSDictionary *)jsonDict;

+ (id<OHHTTPStubsDescriptor>)mockAPI:(NSString *)route fileName:(NSString *)name statusCode:(int)statusCode;

+ (id<OHHTTPStubsDescriptor>)mockAPI:(NSString *)route fileName:(NSString *)name responseTime:(NSTimeInterval)responseTime;

+ (id<OHHTTPStubsDescriptor>)mockAPI:(NSString *)route fileName:(NSString *)name networkSpeed:(MockNetworkSpeed)speed;

+ (id<OHHTTPStubsDescriptor>)mockNoInternetAPI:(NSString *)route;

+ (void)clearMockStub:(id<OHHTTPStubsDescriptor>)stub;

@end
