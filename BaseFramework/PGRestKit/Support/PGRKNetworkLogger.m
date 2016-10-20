//
//  XYRKNetworkLogger.m
//  Penguin
//
//  Created by Jing Dai on 6/30/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#ifdef DEBUG
#define NSLog(format, ...) printf("\n[%s] %s %s\n", __TIME__, __FUNCTION__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(format, ...)
#endif

#import "PGRKNetworkLogger.h"
#import <AFNetworking/AFNetworking.h>

static NSError * AFNetworkErrorFromNotification(NSNotification *notification) {
    NSError *error = nil;
    if ([[notification object] isKindOfClass:[NSURLSessionTask class]]) {
        error = [(NSURLSessionTask *)[notification object] error];
        if (!error) {
            error = notification.userInfo[AFNetworkingTaskDidCompleteErrorKey];
        }
    }
    return error;
}

@implementation PGRKNetworkLogger

+ (PGRKNetworkLogger *)sharedInstance
{
    static PGRKNetworkLogger *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PGRKNetworkLogger alloc] init];
    });
    
    return sharedInstance;
}

- (void)dealloc
{
    [self stopLogging];
}

- (void)startLogging
{
    [self stopLogging];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskDidStart:) name:AFNetworkingTaskDidResumeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskDidFinish:) name:AFNetworkingTaskDidCompleteNotification object:nil];
}

- (void)stopLogging
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - <Private Methods>

- (void)taskDidStart:(NSNotification *)notification
{
    NSURLSessionTask *task = [notification object];
    NSURLRequest *request = task.originalRequest;
    
    if (!request) {
        return;
    }
    
    NSString *body = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@ '%@': %@ %@", [request HTTPMethod], [[request URL] absoluteString], [request allHTTPHeaderFields], body);
}

- (void)taskDidFinish:(NSNotification *)notification
{
    NSURLSessionTask *task = [notification object];
    NSURLRequest *request = task.originalRequest;
    NSURLResponse *response = task.response;
    NSError *error = AFNetworkErrorFromNotification(notification);
    
    if (!request && !response) {
        return;
    }
    
    id responseObject = nil;
    if (!error && notification.userInfo) {
        NSData *responseData = notification.userInfo[AFNetworkingTaskDidCompleteResponseDataKey];
        if (responseData) {
            responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
        }
    }
    
    NSUInteger responseStatusCode = 0;
    NSDictionary *responseHeaderFields = nil;
    if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
        responseStatusCode = (NSUInteger)[(NSHTTPURLResponse *)task.response statusCode];
        responseHeaderFields = [(NSHTTPURLResponse *)task.response allHeaderFields];
    }
    
    if (error) {
        NSLog(@"[Error] %@ '%@' (%ld) %@", [task.originalRequest HTTPMethod], [[task.response URL] absoluteString], (long)responseStatusCode, error);
    } else {
        NSLog(@"%ld '%@' %@ %@", (long)responseStatusCode, [[task.response URL] absoluteString], responseHeaderFields, responseObject);
    }
}

@end
