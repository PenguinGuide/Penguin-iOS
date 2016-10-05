//
//  UIScrollView+PGScrollView.m
//  Penguin
//
//  Created by Jing Dai on 7/22/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define DimViewDefaultAlpha 0.5f

static char HeaderView;
static char RightNaviButton;
static char ImageViewHeight;

static char ScrollViewDimView;
static char ScrollViewNaviTitleLabel;

#import "UIScrollView+PGScrollView.h"
#import <objc/runtime.h>

@interface UIScrollView ()

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *rightNaviButton;
@property (nonatomic, strong) NSNumber *imageViewOriginalHeight;

@property (nonatomic, strong) UIView *dimView;
@property (nonatomic, strong) UILabel *naviTitleLabel;

@end

@implementation UIScrollView (PGScrollView)

- (void)setHeaderView:(UIView *)headerView
{
    [self setHeaderView:headerView naviTitle:nil rightNaviButton:nil];
}

- (void)setHeaderView:(UIView *)headerView naviTitle:(NSString *)naviTitle rightNaviButton:(UIButton *)rightNaviButton
{
    UIView *dimView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.height)];
    dimView.contentMode = UIViewContentModeScaleAspectFill;
    dimView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.0f];
    [headerView addSubview:dimView];
    
    headerView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:headerView];
    
    CGFloat height = headerView.frame.size.height;
    
    if (naviTitle && naviTitle.length > 0) {
        UILabel *naviTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, [UIScreen mainScreen].bounds.size.width-140, 44)];
        naviTitleLabel.font = [UIFont systemFontOfSize:16.f weight:UIFontWeightBold];
        naviTitleLabel.textAlignment = NSTextAlignmentCenter;
        naviTitleLabel.textColor = [UIColor whiteColor];
        naviTitleLabel.text = naviTitle;
        naviTitleLabel.alpha = 0.f;
        [self addSubview:naviTitleLabel];
        
        objc_setAssociatedObject(self, &ScrollViewNaviTitleLabel, naviTitleLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    objc_setAssociatedObject(self, &HeaderView, headerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &RightNaviButton, rightNaviButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &ImageViewHeight, @(height), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &ScrollViewDimView, dimView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)headerView
{
    return objc_getAssociatedObject(self, &HeaderView);
}

- (UIButton *)rightNaviButton
{
    return objc_getAssociatedObject(self, &RightNaviButton);
}

- (NSNumber *)imageViewOriginalHeight
{
    return objc_getAssociatedObject(self, &ImageViewHeight);
}

- (UIView *)dimView
{
    return objc_getAssociatedObject(self, &ScrollViewDimView);
}

- (UILabel *)naviTitleLabel
{
    return objc_getAssociatedObject(self, &ScrollViewNaviTitleLabel);
}

- (void)scrollViewShouldUpdate
{
    if (self.headerView) {
        CGFloat headerImageHeight = [self.imageViewOriginalHeight floatValue];
        CGFloat contentOffsetY = self.contentOffset.y;
        if (self.contentOffset.y > 0) {
            // scroll down
            float scale = contentOffsetY/(self.headerView.frame.size.height-64);
            if (headerImageHeight-contentOffsetY <= 64) {
                self.headerView.frame = CGRectMake(0, contentOffsetY-headerImageHeight+64, self.headerView.frame.size.width, self.headerView.frame.size.height);
                self.dimView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.6f];
                [self bringSubviewToFront:self.headerView];
                [self bringSubviewToFront:self.naviTitleLabel];
            } else {
                self.headerView.frame = CGRectMake(0, 0, self.headerView.frame.size.width, self.headerView.frame.size.height);
                self.dimView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.6f*scale];
            }
            self.naviTitleLabel.frame = CGRectMake(70, 20+contentOffsetY, self.naviTitleLabel.frame.size.width, self.naviTitleLabel.frame.size.height);
            if (scale >= 1.f) {
                self.naviTitleLabel.alpha = 1.f;
            } else if (scale >= 0.5f) {
                self.naviTitleLabel.alpha = 1.f*((contentOffsetY-((self.headerView.frame.size.height-64)/2))/((self.headerView.frame.size.height-64)/2));
            } else {
                self.naviTitleLabel.alpha = 0.f;
            }
        } else {
            // pull refresh
            self.headerView.frame = CGRectMake(0, contentOffsetY, self.headerView.frame.size.width, headerImageHeight+fabs(contentOffsetY));
            self.dimView.frame = CGRectMake(0, 0, self.headerView.frame.size.width, headerImageHeight+fabs(contentOffsetY));
            self.naviTitleLabel.frame = CGRectMake(70, 20, self.naviTitleLabel.frame.size.width, self.naviTitleLabel.frame.size.height);
        }
    }
}

- (void)scrollViewShouldUpdateHeaderView
{
    if (self.headerView) {
        CGFloat headerImageHeight = [self.imageViewOriginalHeight floatValue];
        CGFloat contentOffsetY = self.contentOffset.y;
        if (self.contentOffset.y <= 0) {
            // pull refresh
            self.headerView.frame = CGRectMake(0, contentOffsetY, self.headerView.frame.size.width, headerImageHeight+fabs(contentOffsetY));
            self.dimView.frame = CGRectMake(0, 0, self.headerView.frame.size.width, headerImageHeight+fabs(contentOffsetY));
            self.dimView.userInteractionEnabled = NO;
            self.naviTitleLabel.frame = CGRectMake(70, 20, self.naviTitleLabel.frame.size.width, self.naviTitleLabel.frame.size.height);
        }
    }
}

@end
