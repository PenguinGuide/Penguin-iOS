//
//  PGLoginSocialView.m
//  Penguin
//
//  Created by Jing Dai on 7/6/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGSocialView.h"

@interface PGSocialView ()

@property (nonatomic, strong) UIButton *weixinButton;
@property (nonatomic, strong) UIButton *weiboButton;

@end

@implementation PGSocialView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.weixinButton];
        [self addSubview:self.weiboButton];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 12)];
        label.text = @"- OR -";
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = Theme.fontSmall;
        [self addSubview:label];
    }
    
    return self;
}

- (UIButton *)weixinButton
{
    if (!_weixinButton) {
        _weixinButton = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width-50*2-22)/2, 12, 50, 50)];
        _weixinButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _weixinButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_weixinButton setImage:[UIImage imageNamed:@"pg_login_weixin"] forState:UIControlStateNormal];
    }
    return _weixinButton;
}

- (UIButton *)weiboButton
{
    if (!_weiboButton) {
        _weiboButton = [[UIButton alloc] initWithFrame:CGRectMake(self.weixinButton.pg_right+22, 12, 50, 50)];
        _weiboButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _weiboButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_weiboButton setImage:[UIImage imageNamed:@"pg_login_weibo"] forState:UIControlStateNormal];
    }
    return _weiboButton;
}

@end
