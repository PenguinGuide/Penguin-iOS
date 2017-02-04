//
//  UIView+PGAnalytics.h
//  Penguin
//
//  Created by Kobe Dai on 24/01/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (PGAnalytics)

// event
@property (nonatomic, strong) NSString *eventName;

// params
@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSString *pageName;
@property (nonatomic, strong) NSString *pageId;
@property (nonatomic, strong) NSDictionary *extraParams;

+ (void)setupHook;

@end
