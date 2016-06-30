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

- (void)setTapAction:(void(^)(void))completion;

@end
