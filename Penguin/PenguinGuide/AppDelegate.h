//
//  AppDelegate.h
//  PenguinGuide
//
//  Created by Jing Dai on 6/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong, readonly) PGTabBarController *tabBarController;
@property (nonatomic, assign) BOOL allowRotation;

@end

