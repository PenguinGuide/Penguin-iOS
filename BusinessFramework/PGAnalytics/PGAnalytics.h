//
//  PGAnalytics.h
//  Penguin
//
//  Created by Jing Dai on 8/4/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define event_name @"event_name"
#define event_id @"event_id"
#define page_name @"page_name"
#define page_title @"page_title"
#define page_id @"page_id"

#import <Foundation/Foundation.h>
#import "Aspects.h"
#import "UIApplication+PGAnalytics.h"
#import "UIViewController+PGAnalytics.h"
#import "UIView+PGAnalytics.h"

@interface PGAnalytics : NSObject

+ (void)setup:(NSDictionary *)launchOptions;

+ (void)startPageView:(NSString *)pageView;
+ (void)endPageView:(NSString *)pageView;

+ (void)trackEvent:(NSString *)eventName params:(NSDictionary *)eventParams;

@end
