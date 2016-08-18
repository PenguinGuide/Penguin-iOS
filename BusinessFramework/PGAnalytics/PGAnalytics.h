//
//  PGAnalytics.h
//  Penguin
//
//  Created by Jing Dai on 8/4/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIApplication+PGAnalytics.h"
#import "UIViewController+PGAnalytics.h"

@interface PGAnalytics : NSObject

+ (void)setup:(NSDictionary *)launchOptions;

+ (void)startPageView:(NSString *)pageView;
+ (void)endPageView:(NSString *)pageView;

+ (void)trackEvent:(NSString *)eventName pageView:(NSString *)pageView;
+ (void)trackEvent:(NSString *)eventName pageView:(NSString *)pageView params:(NSDictionary *)params;

+ (void)swizzleMethodWithClass:(Class)class originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;

@end
