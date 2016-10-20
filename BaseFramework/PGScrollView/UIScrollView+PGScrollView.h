//
//  UIScrollView+PGScrollView.h
//  Penguin
//
//  Created by Jing Dai on 7/22/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (PGScrollView)

- (void)setHeaderView:(UIView *)headerView;

- (void)setHeaderView:(UIView *)headerView
            naviTitle:(NSString *)naviTitle
      rightNaviButton:(UIButton *)rightNaviButton;

- (void)scrollViewShouldUpdate;
- (void)scrollViewShouldUpdateHeaderView;

@end
