//
//  PGTabBarController.h
//  Penguin
//
//  Created by Jing Dai on 6/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGTabBarControllerDelegate.h"

@interface PGTabBarController : UIViewController

@property (nonatomic, strong, readonly) NSArray *viewControllers;

- (void)setViewControllers:(NSArray *)viewControllers;
- (void)selectTab:(NSInteger)index;

@end
