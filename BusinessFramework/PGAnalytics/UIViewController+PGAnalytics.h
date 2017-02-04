//
//  UIViewController+PGAnalytics.h
//  Penguin
//
//  Created by Jing Dai on 8/4/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (PGAnalytics)

// event
@property (nonatomic, strong) NSString *pageName;

// params
@property (nonatomic, strong) NSString *pageTitle;
@property (nonatomic, strong) NSString *pageId;

+ (void)setupHook;

@end
