//
//  PGAnalytics.m
//  Penguin
//
//  Created by Jing Dai on 8/4/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGAnalytics.h"
#import <objc/runtime.h>
#import "Zhuge.h"
#import "UMMobClick/MobClick.h"

@interface NSString (PGAnalytics)

- (BOOL)isValid;

@end

@implementation NSString (PGAnalytics)

- (BOOL)isValid
{
    return self && self.length > 0;
}

@end

@interface NSDictionary (PGAnalytics)

- (BOOL)isValid;

@end

@implementation NSDictionary (PGAnalytics)

- (BOOL)isValid
{
    return self && self.count > 0;
}

@end

@implementation PGAnalytics

+ (void)setup:(NSDictionary *)launchOptions
{
    [[Zhuge sharedInstance] startWithAppKey:@"cc9eb0f7ede346909f476873b364fc1e"
                              launchOptions:launchOptions];
    
    UMConfigInstance.appKey = @"588581ea677baa1c55002517";
    [MobClick startWithConfigure:UMConfigInstance];
    
    [UIApplication setupHook];
    [UIViewController setupHook];
    [UIView setupHook];
}

+ (void)startPageView:(NSString *)pageView
{
    if (pageView.isValid) {
        [MobClick beginLogPageView:pageView];
    }
}

+ (void)endPageView:(NSString *)pageView
{
    if (pageView.isValid) {
        [MobClick endLogPageView:pageView];
    }
}

+ (void)trackEvent:(NSString *)eventName params:(NSDictionary *)eventParams
{
    if (eventName.isValid) {
        NSLog(@"track event: %@, params: %@", eventName, eventParams);
        
        if (eventParams.isValid) {
            [MobClick event:eventName attributes:eventParams];
            [[Zhuge sharedInstance] track:eventName properties:eventParams];
        } else {
            [MobClick event:eventName];
            [[Zhuge sharedInstance] track:eventName];
        }
    }
}

@end
