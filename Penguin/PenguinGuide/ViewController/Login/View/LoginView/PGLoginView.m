//
//  PGLoginView.m
//  Penguin
//
//  Created by Jing Dai on 7/6/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGLoginView.h"

@interface PGLoginView ()

@property (nonatomic, strong, readwrite) PGLoginPhoneTextField *phoneTextField;
@property (nonatomic, strong, readwrite) UIButton *pwdLoginButton;
@property (nonatomic, strong, readwrite) PGSocialView *socialView;
@property (nonatomic, strong, readwrite) UIButton *nextButton;

@end

@implementation PGLoginView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.nextButton];
        [self addSubview:self.phoneTextField];
        [self addSubview:self.pwdLoginButton];
        [self addSubview:self.socialView];
    }
    
    return self;
}

- (PGLoginPhoneTextField *)phoneTextField
{
    if (!_phoneTextField) {
        _phoneTextField = [[PGLoginPhoneTextField alloc] initWithFrame:CGRectMake(22, self.logoView.bottom+18, self.frame.size.width-22*2, 46)];
    }
    return _phoneTextField;
}

- (UIButton *)pwdLoginButton
{
    if (!_pwdLoginButton) {
        _pwdLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width/2-40, self.phoneTextField.bottom+18, 80, 40)];
        [_pwdLoginButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_pwdLoginButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [_pwdLoginButton setTitle:@"密码登录" forState:UIControlStateNormal];
        [_pwdLoginButton setTitleColor:[UIColor colorWithHexString:@"ef6733"] forState:UIControlStateNormal];
        [_pwdLoginButton setImage:[UIImage imageNamed:@"pg_login_password"] forState:UIControlStateNormal];
        [_pwdLoginButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [_pwdLoginButton.titleLabel setFont:Theme.fontMedium];
        
        UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(4, 21, 72, 1)];
        horizontalLine.backgroundColor = [UIColor colorWithHexString:@"ef6733"];
        [_pwdLoginButton addSubview:horizontalLine];
    }
    return _pwdLoginButton;
}

- (PGSocialView *)socialView
{
    if (!_socialView) {
        _socialView = [[PGSocialView alloc] initWithFrame:CGRectMake(0, self.pwdLoginButton.bottom+28, self.width, 62)];
    }
    return _socialView;
}

- (UIButton *)nextButton
{
    if (!_nextButton) {
        if (DEVICE_IS_LESS_OR_EQUAL_TO_IPHONE_5) {
            _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(26, self.height-22-30, self.width-26*2, 30)];
        } else {
            _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(26, self.height-22-45, self.width-26*2, 45)];
        }
        [_nextButton setBackgroundColor:[UIColor blackColor]];
        [_nextButton setTitle:@"下 一 步" forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextButton.titleLabel setFont:Theme.fontMedium];
        
        _nextButton.clipsToBounds = YES;
        _nextButton.layer.cornerRadius = 2.f;
    }
    return _nextButton;
}

@end
