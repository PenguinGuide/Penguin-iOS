//
//  UIView+PGView.h
//  Penguin
//
//  Created by Jing Dai on 6/30/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (PGView)

@property (nonatomic) CGFloat pg_x;
@property (nonatomic) CGFloat pg_y;
@property (nonatomic) CGFloat pg_width;
@property (nonatomic) CGFloat pg_height;

@property (nonatomic) CGFloat pg_left;
@property (nonatomic) CGFloat pg_right;
@property (nonatomic) CGFloat pg_top;
@property (nonatomic) CGFloat pg_bottom;

- (void)setTapAction:(void(^)(void))completion;
- (UIImage *)screenshot;
- (UIImage *)screenshotFromRect:(CGRect)rect;

@end
