//
//  PGLoginSocialView.m
//  Penguin
//
//  Created by Jing Dai on 12/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGLoginSocialView.h"

@implementation PGLoginSocialView

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
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, 10)];
    topLabel.backgroundColor = [UIColor clearColor];
    topLabel.font = Theme.fontExtraSmallBold;
    topLabel.textColor = [UIColor whiteColor];
    topLabel.text = @"OR";
    topLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:topLabel];
    
    UIView *leftHorizontalView = [[UIView alloc] initWithFrame:CGRectMake(0, (10-1/[UIScreen mainScreen].scale)/2, (self.pg_width-50)/2, 1/[UIScreen mainScreen].scale)];
    leftHorizontalView.backgroundColor = [UIColor whiteColor];
    
    UIView *rightHorizontalView = [[UIView alloc] initWithFrame:CGRectMake(self.pg_width/2+25, (10-1/[UIScreen mainScreen].scale)/2, (self.pg_width-50)/2, 1/[UIScreen mainScreen].scale)];
    rightHorizontalView.backgroundColor = [UIColor whiteColor];
    
    [topLabel addSubview:leftHorizontalView];
    [topLabel addSubview:rightHorizontalView];
    
    UIView *socialView = [[UIView alloc] initWithFrame:CGRectMake((self.pg_width-(115+50+50))/2, topLabel.pg_bottom+3, 115+50+50, 50)];
    socialView.backgroundColor = [UIColor clearColor];
    [self addSubview:socialView];
    
    self.socialLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (50-14)/2.f, 115, 14)];
    self.socialLabel.font = Theme.fontSmallBold;
    self.socialLabel.textColor = [UIColor whiteColor];
    self.socialLabel.text = @"使用其他方式登录：";
    [socialView addSubview:self.socialLabel];
    
    UIButton *weixinButton = [[UIButton alloc] initWithFrame:CGRectMake(self.socialLabel.pg_right, 0, 50, 50)];
    [weixinButton addTarget:self action:@selector(weixinButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [weixinButton setImage:[UIImage imageNamed:@"pg_login_wechat"] forState:UIControlStateNormal];
    [socialView addSubview:weixinButton];
    
    UIButton *weiboButton = [[UIButton alloc] initWithFrame:CGRectMake(weixinButton.pg_right, 0, 50, 50)];
    [weiboButton addTarget:self action:@selector(weiboButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [weiboButton setImage:[UIImage imageNamed:@"pg_login_weibo"] forState:UIControlStateNormal];
    [socialView addSubview:weiboButton];
}

- (void)weixinButtonClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(weixinButtonClicked)]) {
        [self.delegate weixinButtonClicked];
    }
}

- (void)weiboButtonClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(weiboButtonClicked)]) {
        [self.delegate weiboButtonClicked];
    }
}

@end
