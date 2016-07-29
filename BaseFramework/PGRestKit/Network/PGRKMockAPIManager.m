//
//  PGRKMockAPIManager.m
//  Penguin
//
//  Created by Jing Dai on 7/12/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGRKMockAPIManager.h"
#import "OHPathHelpers.h"
#import "OHHTTPStubsResponse+JSON.h"

@implementation PGRKMockAPIManager

+ (id<OHHTTPStubsDescriptor>)mockAPI:(NSString *)route fileName:(NSString *)name
{
#if (defined ADHOC) || (defined DEBUG)
    return [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest * _Nonnull request) {
        BOOL matched = NO;
        if ([route isEqualToString:request.URL.path]) {
            matched = YES;
        }
        if ([route rangeOfString:request.URL.path].location != NSNotFound) {
            matched = YES;
        }
        return matched;
    } withStubResponse:^OHHTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request) {
        NSString *fileName = name;
        if ([fileName rangeOfString:@".json"].location == NSNotFound) {
            fileName = [fileName stringByAppendingString:@".json"];
        }
        NSString *fixture = OHPathForFile(fileName, [PGRKMockAPIManager class]);
        return [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:200 headers:@{@"Content-Type":@"application/json"}];
    }];
#endif
}

+ (id<OHHTTPStubsDescriptor>)mockAPI:(NSString *)route jsonDict:(NSDictionary *)jsonDict
{
#if (defined ADHOC) || (defined DEBUG)
    return [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest * _Nonnull request) {
        BOOL matched = NO;
        if ([route isEqualToString:request.URL.path]) {
            matched = YES;
        }
        if ([route rangeOfString:request.URL.path].location != NSNotFound) {
            matched = YES;
        }
        return matched;
    } withStubResponse:^OHHTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request) {
        return [OHHTTPStubsResponse responseWithJSONObject:jsonDict statusCode:200 headers:nil];
    }];
#endif
}

+ (id<OHHTTPStubsDescriptor>)mockAPI:(NSString *)route fileName:(NSString *)name statusCode:(int)statusCode
{
#if (defined ADHOC) || (defined DEBUG)
    return [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest * _Nonnull request) {
        BOOL matched = NO;
        if ([route isEqualToString:request.URL.path]) {
            matched = YES;
        }
        if ([route rangeOfString:request.URL.path].location != NSNotFound) {
            matched = YES;
        }
        return matched;
    } withStubResponse:^OHHTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request) {
        NSString *fileName = name;
        if ([fileName rangeOfString:@".json"].location == NSNotFound) {
            fileName = [fileName stringByAppendingString:@".json"];
        }
        NSString *fixture = OHPathForFile(fileName, [PGRKMockAPIManager class]);
        return [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:statusCode headers:@{@"Content-Type":@"application/json"}];
    }];
#endif
}

+ (id<OHHTTPStubsDescriptor>)mockAPI:(NSString *)route fileName:(NSString *)name responseTime:(NSTimeInterval)responseTime
{
#if (defined ADHOC) || (defined DEBUG)
    return [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest * _Nonnull request) {
        BOOL matched = NO;
        if ([route isEqualToString:request.URL.path]) {
            matched = YES;
        }
        if ([route rangeOfString:request.URL.path].location != NSNotFound) {
            matched = YES;
        }
        return matched;
    } withStubResponse:^OHHTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request) {
        NSString *fileName = name;
        if ([fileName rangeOfString:@".json"].location == NSNotFound) {
            fileName = [fileName stringByAppendingString:@".json"];
        }
        NSString *fixture = OHPathForFile(fileName, [PGRKMockAPIManager class]);
        OHHTTPStubsResponse *response = [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        return [response requestTime:0.0 responseTime:responseTime];
    }];
#endif
}

+ (id<OHHTTPStubsDescriptor>)mockAPI:(NSString *)route fileName:(NSString *)name networkSpeed:(MockNetworkSpeed)speed
{
#if (defined ADHOC) || (defined DEBUG)
    return [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest * _Nonnull request) {
        BOOL matched = NO;
        if ([route isEqualToString:request.URL.path]) {
            matched = YES;
        }
        if ([route rangeOfString:request.URL.path].location != NSNotFound) {
            matched = YES;
        }
        return matched;
    } withStubResponse:^OHHTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request) {
        NSString *fileName = name;
        if ([fileName rangeOfString:@".json"].location == NSNotFound) {
            fileName = [fileName stringByAppendingString:@".json"];
        }
        NSString *fixture = OHPathForFile(fileName, [PGRKMockAPIManager class]);
        OHHTTPStubsResponse *response = [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        NSTimeInterval networkSpeed = OHHTTPStubsDownloadSpeedSLOW;
        switch (speed) {
            case MockDownloadSpeedSlow:
                networkSpeed = OHHTTPStubsDownloadSpeedSLOW;
                break;
            case MockDownloadSpeedGPRS:
                networkSpeed = OHHTTPStubsDownloadSpeedGPRS;
                break;
            case MockDownloadSpeedEDGE:
                networkSpeed = OHHTTPStubsDownloadSpeedEDGE;
                break;
            case MockDownloadSpeed3G:
                networkSpeed = OHHTTPStubsDownloadSpeed3G;
                break;
            case MockDownloadSpeed4G:
                networkSpeed = OHHTTPStubsDownloadSpeed3GPlus;
                break;
            case MockDownloadSpeedWifi:
                networkSpeed = OHHTTPStubsDownloadSpeedWifi;
            default:
                break;
        }
        return [response requestTime:0.0 responseTime:networkSpeed];
    }];
#endif
}

+ (id<OHHTTPStubsDescriptor>)mockNoInternetAPI:(NSString *)route
{
#if (defined ADHOC) || (defined DEBUG)
    return [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest * _Nonnull request) {
        BOOL matched = NO;
        if ([route isEqualToString:request.URL.path]) {
            matched = YES;
        }
        if ([route rangeOfString:request.URL.path].location != NSNotFound) {
            matched = YES;
        }
        return matched;
    } withStubResponse:^OHHTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request) {
        NSError *noConnectionError = [NSError errorWithDomain:NSURLErrorDomain code:kCFURLErrorNotConnectedToInternet userInfo:nil];
        return [OHHTTPStubsResponse responseWithError:noConnectionError];
    }];
#endif
}

+ (void)clearMockStub:(id<OHHTTPStubsDescriptor>)stub
{
#if (defined ADHOC) || (defined DEBUG)
    [OHHTTPStubs removeStub:stub];
#endif
}

- (void)dealloc
{
#if (defined ADHOC) || (defined DEBUG)
    [OHHTTPStubs removeAllStubs];
#endif
}

@end
