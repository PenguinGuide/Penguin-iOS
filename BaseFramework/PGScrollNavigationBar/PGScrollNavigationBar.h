//
//  PGScrollNavigationBar.h
//  Penguin
//
//  Created by Jing Dai on 7/13/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

typedef NS_ENUM(NSInteger, PGScrollNavigationBarState) {
    PGScrollNavigationBarStateNone,
    PGScrollNavigationBarStateScrollingDown,
    PGScrollNavigationBarStateScrollingUp
};

#import <UIKit/UIKit.h>

@interface PGScrollNavigationBar : UINavigationBar

@property (nonatomic, strong) UIScrollView *scrollView;
@property (assign, nonatomic) PGScrollNavigationBarState scrollState;

- (void)resetToDefaultPositionWithAnimation:(BOOL)animated;

@end

@interface UINavigationController (PGScrollNavigationBarAdditions)

@property (nonatomic, strong, readonly) PGScrollNavigationBar *scrollNavigationBar;

@end
