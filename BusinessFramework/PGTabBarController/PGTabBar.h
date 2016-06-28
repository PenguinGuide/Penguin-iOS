//
//  PGTabBar.h
//  Penguin
//
//  Created by Jing Dai on 6/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGTabBar : UIView

@property (nonatomic, strong, readonly) NSArray *tabs;

- (void)setTabs:(NSArray *)tabs;

@end
