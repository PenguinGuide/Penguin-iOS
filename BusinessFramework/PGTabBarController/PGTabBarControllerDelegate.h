//
//  PGTabBarControllerDelegate.h
//  Penguin
//
//  Created by Jing Dai on 6/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PGTabBarControllerDelegate <NSObject>

@required

/**
 *  tab bar title
 */
- (NSString *)tabBarTitle;

/**
 *  tab bar normal icon image
 */
- (NSString *)tabBarImage;

/**
 *  tab bar highlight icon image
 */
- (NSString *)tabBarHighlightImage;

@optional

/**
 *  tab bar did clicked
 */
- (void)tabBarDidClicked;

/**
 *  child view controller should be clicked
 */
- (BOOL)tabBarShouldClicked;

@end
