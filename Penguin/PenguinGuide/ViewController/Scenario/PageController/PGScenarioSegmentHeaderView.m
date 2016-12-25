//
//  PGScenarioSegmentHeaderView.m
//  Penguin
//
//  Created by Jing Dai on 05/12/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGScenarioSegmentHeaderView.h"

@interface PGScenarioSegmentHeaderView ()

@property (weak, nonatomic) NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) NSLayoutConstraint *widthConstraint;

@property (nonatomic, strong) UIView *dimView;
@property (nonatomic, strong) UILabel *naviTitleLabel;

@property (nonatomic, assign) CGFloat imageViewHeight;
@property (nonatomic, assign) CGFloat initialRatio;

@end

@implementation PGScenarioSegmentHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.backgroundColor = [UIColor lightGrayColor];
    
    self.naviTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, [UIScreen mainScreen].bounds.size.width-140, 44)];
    self.naviTitleLabel.font = [UIFont systemFontOfSize:16.f weight:UIFontWeightBold];
    self.naviTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.naviTitleLabel.textColor = [UIColor blackColor];
    self.naviTitleLabel.alpha = 0.f;
    [self addSubview:self.naviTitleLabel];
    
    self.dimView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.dimView.contentMode = UIViewContentModeScaleAspectFill;
    self.dimView.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.0f];
    [self addSubview:self.dimView];
    
    self.imageViewHeight = self.frame.size.height;
    self.initialRatio = (UISCREEN_WIDTH*9/16 - 64)/self.pg_height;
}

- (void)setNaviTitle:(NSString *)title
{
    self.naviTitleLabel.text = title;
}

- (void)updateHeadPhotoWithTopInset:(CGFloat)inset
{
    CGFloat ratio = (inset - 64)/self.pg_height;

    self.dimView.frame = CGRectMake(0, 0, self.pg_width, inset);
    [self bringSubviewToFront:self.dimView];
    
    if (ratio == 0) {
        self.dimView.backgroundColor = [UIColor colorWithWhite:1.f alpha:1.f];
        self.naviTitleLabel.alpha = 1.f;
        [self bringSubviewToFront:self.naviTitleLabel];
    } else if (inset <= UISCREEN_WIDTH*9/16) {
        self.dimView.backgroundColor = [UIColor colorWithWhite:1.f alpha:1.f*(1.f-ratio)];
        self.naviTitleLabel.alpha = 0.f;
    } else {
        self.dimView.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.f];
        self.naviTitleLabel.alpha = 0.f;
    }
}

@end
