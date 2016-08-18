//
//  UIApplication+PGAnalytics.m
//  Penguin
//
//  Created by Jing Dai on 8/4/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "UIApplication+PGAnalytics.h"
#import "PGAnalytics.h"

@implementation UIApplication (PGAnalytics)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [PGAnalytics swizzleMethodWithClass:[self class]
                           originalSelector:@selector(sendAction:to:from:forEvent:)
                           swizzledSelector:@selector(swizzled_sendAction:to:from:forEvent:)];
    });
}

- (BOOL)swizzled_sendAction:(SEL)action to:(nullable id)target from:(nullable id)sender forEvent:(nullable UIEvent *)event
{
    // this calls the original sendAction method
    BOOL result = [self swizzled_sendAction:action to:target from:sender forEvent:event];
    
    if (![NSStringFromSelector(action) isEqualToString:@"_sendAction:withEvent:"]) {
        if ([target respondsToSelector:@selector(pageView)]) {
            if ([target pageView]) {
                [PGAnalytics trackEvent:NSStringFromSelector(action) pageView:[target pageView]];
            } else {
                [PGAnalytics trackEvent:NSStringFromSelector(action) pageView:NSStringFromClass([target class])];
            }
        } else {
            [PGAnalytics trackEvent:NSStringFromSelector(action) pageView:NSStringFromClass([target class])];
        }
    }
    
    return result;
}

@end
