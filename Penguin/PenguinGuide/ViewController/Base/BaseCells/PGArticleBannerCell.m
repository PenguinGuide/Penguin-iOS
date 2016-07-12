//
//  PGArticleBannerCell.m
//  Penguin
//
//  Created by Jing Dai on 7/12/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGArticleBannerCell.h"

@interface PGArticleBannerCell () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *bannerImageView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIImageView *collectImageView;
@property (nonatomic, strong) UILabel *collectLabel;

@end

@implementation PGArticleBannerCell

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
    self.backgroundColor = Theme.colorHighlight;
    
    [self.contentView addSubview:self.collectImageView];
    [self.contentView addSubview:self.collectLabel];
    [self.contentView addSubview:self.bannerImageView];
    [self addGestureRecognizer:self.panGesture];
}

- (void)setCellWithImage:(NSString *)image
{
    self.bannerImageView.image = [UIImage imageNamed:image];
}

+ (CGSize)cellSize
{
    return CGSizeMake(UISCREEN_WIDTH, UISCREEN_WIDTH*180/320);
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self];
    // move left
    if ([recognizer velocityInView:self].x < 0.f) {
        PGLogWarning(@"move left: %@", NSStringFromCGPoint(translation));
        // move right
    } else {
        CGPoint translation = [recognizer translationInView:self];
        PGLogWarning(@"move right: %@", NSStringFromCGPoint(translation));
    }
    if (translation.x > 0) {
        self.bannerImageView.frame = CGRectMake(0, self.bannerImageView.y, self.bannerImageView.width, self.bannerImageView.height);
    } else if (translation.x >= -90) {
        self.bannerImageView.frame = CGRectMake(translation.x, self.bannerImageView.y, self.bannerImageView.width, self.bannerImageView.height);
    } else {
        self.bannerImageView.frame = CGRectMake(-90, self.bannerImageView.y, self.bannerImageView.width, self.bannerImageView.height);
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateFailed || recognizer.state == UIGestureRecognizerStateCancelled) {
        [UIView animateWithDuration:0.4f
                              delay:0.f
             usingSpringWithDamping:0.9f
              initialSpringVelocity:0.9f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.bannerImageView.frame = CGRectMake(0, self.bannerImageView.y, self.bannerImageView.width, self.bannerImageView.height);
                         } completion:^(BOOL finished) {
                            
                         }];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer *)gestureRecognizer;
    CGPoint velocity = [recognizer velocityInView:self];
    if (abs((int)velocity.y) >= abs((int)velocity.x)) {
        return NO;
    } else {
        return YES;
    }
}

- (UIImageView *)bannerImageView
{
    if (!_bannerImageView) {
        _bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _bannerImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bannerImageView;
}

- (UIPanGestureRecognizer *)panGesture
{
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
        _panGesture.delegate = self;
    }
    return _panGesture;
}

- (UIImageView *)collectImageView
{
    if (!_collectImageView) {
        _collectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width-32-24, self.height/2-14-18, 24, 28)];
        _collectImageView.image = [UIImage imageNamed:@"pg_home_article_collect"];
    }
    return _collectImageView;
}

- (UILabel *)collectLabel
{
    if (!_collectLabel) {
        _collectLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width-90, self.collectImageView.bottom+6, 85, 14)];
        _collectLabel.font = Theme.fontSmall;
        _collectLabel.textColor = [UIColor whiteColor];
        _collectLabel.textAlignment = NSTextAlignmentCenter;
        _collectLabel.text = @"收藏";
    }
    return _collectLabel;
}

@end
