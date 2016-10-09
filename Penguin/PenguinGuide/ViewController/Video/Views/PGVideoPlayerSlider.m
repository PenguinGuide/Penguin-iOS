//
//  PGVideoPlayerSlider.m
//  Penguin
//
//  Created by Jing Dai on 24/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define LineHeight 2.f

#import "PGVideoPlayerSlider.h"

@interface PGVideoPlayerSlider ()

@property (nonatomic, strong) UIView *minimumTrackLine;
@property (nonatomic, strong) UIView *maximumTrackLine;

@end

@implementation PGVideoPlayerSlider

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // NOTE: customize UISlider https://my.oschina.net/u/2340880/blog/401902
        self.minimumTrackTintColor = [UIColor clearColor];
        self.maximumTrackTintColor = [UIColor clearColor];
        
        [self setThumbImage:[UIImage imageNamed:@"pg_video_player_slider_thumb"] forState:UIControlStateNormal];
        
        [self addSubview:self.minimumTrackLine];
        [self addSubview:self.maximumTrackLine];
        
        [self addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (void)setValue:(float)value
{
    [super setValue:value];
    
    float minimumTrackValue = (self.pg_width-self.currentThumbImage.size.width)*self.value;
    
    self.minimumTrackLine.frame = CGRectMake(0, self.pg_height/2-LineHeight/2, minimumTrackValue, LineHeight);
    self.maximumTrackLine.frame = CGRectMake(self.minimumTrackLine.pg_right+self.currentThumbImage.size.width, self.pg_height/2-LineHeight/2, self.pg_width-self.minimumTrackLine.pg_right-self.currentThumbImage.size.width, LineHeight);
}

- (void)sliderValueChanged:(UISlider *)slider
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerSliderValueChanged)]) {
        [self.delegate playerSliderValueChanged];
    }
    
    float minimumTrackValue = (self.pg_width-self.currentThumbImage.size.width)*slider.value;
    
    self.minimumTrackLine.frame = CGRectMake(0, self.pg_height/2-LineHeight/2, minimumTrackValue, LineHeight);
    self.maximumTrackLine.frame = CGRectMake(self.minimumTrackLine.pg_right+self.currentThumbImage.size.width, self.pg_height/2-LineHeight/2, self.pg_width-self.minimumTrackLine.pg_right-self.currentThumbImage.size.width, LineHeight);
}

- (UIView *)minimumTrackLine
{
    if (!_minimumTrackLine) {
        _minimumTrackLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.pg_height/2-LineHeight/2, 0, LineHeight)];
        _minimumTrackLine.backgroundColor = [UIColor whiteColor];
    }
    return _minimumTrackLine;
}

- (UIView *)maximumTrackLine
{
    if (!_maximumTrackLine) {
        _maximumTrackLine = [[UIView alloc] initWithFrame:CGRectMake(self.currentThumbImage.size.width, self.pg_height/2-LineHeight/2, self.pg_width-self.currentThumbImage.size.width, LineHeight)];
        _maximumTrackLine.backgroundColor = [UIColor colorWithHexString:@"E1E1E1"];
    }
    return _maximumTrackLine;
}

@end
