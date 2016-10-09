//
//  PGVideoVolumnSlider.m
//  Penguin
//
//  Created by Jing Dai on 24/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define LineWidth 2.f

#import "PGVideoVolumeSlider.h"

@interface PGVideoVolumeSlider ()


@property (nonatomic, strong) UIImageView *maximumTrackImageView;
@property (nonatomic, strong) UIView *maximumTrackLine;
@property (nonatomic, strong) UIImageView *minimumTrackImageView;
@property (nonatomic, strong) UIView *minimumTrackLine;

@end

@implementation PGVideoVolumeSlider

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.maximumTrackImageView];
        [self addSubview:self.maximumTrackLine];
        [self addSubview:self.minimumTrackLine];
        [self addSubview:self.minimumTrackImageView];
    }
    return self;
}

- (void)setValue:(float)value
{
    self.maximumTrackLine.frame = CGRectMake(10, self.maximumTrackImageView.pg_bottom+7, LineWidth, 88*(1-value));
    self.minimumTrackLine.frame = CGRectMake(10, self.maximumTrackLine.pg_bottom, LineWidth, 88*value);
}

#pragma mark - <Setters && Getters>

- (UIImageView *)maximumTrackImageView
{
    if (!_maximumTrackImageView) {
        _maximumTrackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 15)];
        _maximumTrackImageView.image = [UIImage imageNamed:@"pg_video_volumn_slider_max"];
    }
    return _maximumTrackImageView;
}

- (UIView *)maximumTrackLine
{
    if (!_maximumTrackLine) {
        _maximumTrackLine = [[UIView alloc] initWithFrame:CGRectMake(10, self.maximumTrackImageView.pg_bottom+7, LineWidth, 44)];
        _maximumTrackLine.backgroundColor = [UIColor colorWithHexString:@"E1E1E1"];
    }
    return _maximumTrackLine;
}

- (UIView *)minimumTrackLine
{
    if (!_minimumTrackLine) {
        _minimumTrackLine = [[UIView alloc] initWithFrame:CGRectMake(10, self.maximumTrackLine.pg_bottom, LineWidth, 44)];
        _minimumTrackLine.backgroundColor = [UIColor whiteColor];
    }
    return _minimumTrackLine;
}

- (UIImageView *)minimumTrackImageView
{
    if (!_minimumTrackImageView) {
        _minimumTrackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, self.minimumTrackLine.pg_bottom+7, 20, 16)];
        _minimumTrackImageView.image = [UIImage imageNamed:@"pg_video_volumn_slider_min"];
    }
    return _minimumTrackImageView;
}

@end
