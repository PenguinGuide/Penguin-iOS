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

@implementation PGAnalytics

+ (void)setup:(NSDictionary *)launchOptions
{
    [[Zhuge sharedInstance] startWithAppKey:@"cc9eb0f7ede346909f476873b364fc1e"
                              launchOptions:launchOptions];
    
    UMConfigInstance.appKey = @"57a306ff67e58e4d9900215a";
    [MobClick startWithConfigure:UMConfigInstance];
}

+ (void)startPageView:(NSString *)pageView
{
    if (pageView.isValid) {
        [MobClick beginLogPageView:pageView];
        [[Zhuge sharedInstance] track:[NSString stringWithFormat:@"查看%@", pageView]];
    }
}

+ (void)endPageView:(NSString *)pageView
{
    if (pageView.isValid) {
        [MobClick endLogPageView:pageView];
    }
}

+ (void)trackEvent:(NSString *)eventName pageView:(NSString *)pageView
{
    if (eventName.isValid && pageView.isValid) {
        NSMutableDictionary *properties = [NSMutableDictionary dictionary];
        properties[@"Page View"] = pageView;
        
        [[Zhuge sharedInstance] track:[NSString stringWithFormat:@"%@+%@", pageView, eventName] properties:properties];
    }
}

+ (void)trackEvent:(NSString *)eventName pageView:(NSString *)pageView params:(NSDictionary *)params
{
    if (eventName.isValid && pageView.isValid && params) {
        NSMutableDictionary *properties = [NSMutableDictionary dictionary];
        properties[@"Page View"] = pageView;
        properties[@"Attributes"] = params;
        
        [[Zhuge sharedInstance] track:[NSString stringWithFormat:@"%@+%@", pageView, eventName] properties:properties];
    }
}

+ (void)swizzleMethodWithClass:(Class)class originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector
{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    IMP originalMethodImp = method_getImplementation(originalMethod);
    IMP swizzledMethodImp = method_getImplementation(swizzledMethod);
    
    // check the method exists or not http://tech.glowing.com/cn/method-swizzling-aop/
    BOOL didAddMethod = class_addMethod(class, originalSelector, swizzledMethodImp, method_getTypeEncoding(swizzledMethod));
    
    // YES if the method was added successfully, otherwise NO (for example, the class already contains a method implementation with that name).
    if (didAddMethod) {
        class_replaceMethod(class, swizzledMethod, originalMethodImp, method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
