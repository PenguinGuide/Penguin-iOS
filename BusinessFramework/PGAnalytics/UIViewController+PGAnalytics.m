//
//  UIViewController+PGAnalytics.m
//  Penguin
//
//  Created by Jing Dai on 8/4/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

static char PageView;

#import "UIViewController+PGAnalytics.h"
#import "PGAnalytics.h"
#import <objc/runtime.h>

@implementation UIViewController (PGAnalytics)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [PGAnalytics swizzleMethodWithClass:[self class] originalSelector:@selector(viewWillAppear:) swizzledSelector:@selector(swizzled_viewWillAppear:)];
        [PGAnalytics swizzleMethodWithClass:[self class] originalSelector:@selector(viewWillDisappear:) swizzledSelector:@selector(swizzled_viewWillDisappear:)];
    });
}

- (void)swizzled_viewDidLoad
{
    
}

- (void)swizzled_viewWillAppear:(BOOL)animated
{
    [self swizzled_viewWillAppear:animated];
    
    NSString *className = NSStringFromClass([self class]);
    if ([className containsString:@"ViewController"]) {
        NSString *pageView = self.pageView?self.pageView:NSStringFromClass([self class]);
        [PGAnalytics startPageView:pageView];
    }
}

- (void)swizzled_viewWillDisappear:(BOOL)animated
{
    [self swizzled_viewWillDisappear:animated];
    
    NSString *className = NSStringFromClass([self class]);
    if ([className containsString:@"ViewController"]) {
        NSString *pageView = self.pageView?self.pageView:NSStringFromClass([self class]);
        [PGAnalytics endPageView:pageView];
    }
}

- (void)setPageView:(NSString *)pageView
{
    objc_setAssociatedObject(self, &PageView, pageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)pageView
{
    return objc_getAssociatedObject(self, &PageView);
}

@end
