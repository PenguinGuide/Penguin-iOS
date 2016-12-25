//
//  PGScenarioSegmentHeaderView.h
//  Penguin
//
//  Created by Jing Dai on 05/12/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGScenarioSegmentHeaderView : UIView

@property (weak, nonatomic) UIImageView *imageView;

- (void)setNaviTitle:(NSString *)title;
- (void)updateHeadPhotoWithTopInset:(CGFloat)inset;

@end
