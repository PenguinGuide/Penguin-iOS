//
//  UIView+PGView.h
//  Penguin
//
//  Created by Jing Dai on 6/30/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (PGView)

@property (nonatomic) float x;
@property (nonatomic) float y;
@property (nonatomic) float width;
@property (nonatomic) float height;

@property (nonatomic) float left;
@property (nonatomic) float right;
@property (nonatomic) float top;
@property (nonatomic) float bottom;

- (void)setTapAction:(void(^)(void))completion;
- (UIImage *)screenshot;
- (UIImage *)screenshotFromRect:(CGRect)rect;

@end
