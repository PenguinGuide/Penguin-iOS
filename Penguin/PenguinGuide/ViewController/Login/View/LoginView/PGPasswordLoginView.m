//
//  PGPasswordLoginView.m
//  Penguin
//
//  Created by Jing Dai on 7/7/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGPasswordLoginView.h"

@interface PGPasswordLoginView ()

@property (nonatomic, strong, readwrite) PGLoginPhoneTextField *phoneTextField;
@property (nonatomic, strong, readwrite) PGLoginPasswordTextField *pwdTextField;
@property (nonatomic, strong, readwrite) UIButton *forgotPwdButton;
@property (nonatomic, strong, readwrite) UIButton *loginButton;

@end

@implementation PGPasswordLoginView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.phoneTextField];
        [self addSubview:self.pwdTextField];
        [self addSubview:self.forgotPwdButton];
        [self addSubview:self.loginButton];
    }
    
    return self;
}

- (PGLoginPhoneTextField *)phoneTextField
{
    if (!_phoneTextField) {
        _phoneTextField = [[PGLoginPhoneTextField alloc] initWithFrame:CGRectMake(22, self.logoView.bottom+18, self.width-22*2, 46)];
    }
    return _phoneTextField;
}

- (PGLoginPasswordTextField *)pwdTextField
{
    if (!_pwdTextField) {
        _pwdTextField = [[PGLoginPasswordTextField alloc] initWithFrame:CGRectMake(22, self.phoneTextField.bottom+29, self.width-22*2, 46)];
    }
    return _pwdTextField;
}

- (UIButton *)forgotPwdButton
{
    if (!_forgotPwdButton) {
        _forgotPwdButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width/2-40, self.pwdTextField.bottom+18, 80, 40)];
        [_forgotPwdButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_forgotPwdButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [_forgotPwdButton setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forgotPwdButton setTitleColor:[UIColor colorWithHexString:@"ef6733"] forState:UIControlStateNormal];
        [_forgotPwdButton setImage:[UIImage imageNamed:@"pg_login_forgot_password"] forState:UIControlStateNormal];
        [_forgotPwdButton setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
        [_forgotPwdButton.titleLabel setFont:Theme.fontMedium];
        
        UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(4, 21, 72, 1)];
        horizontalLine.backgroundColor = [UIColor colorWithHexString:@"ef6733"];
        [_forgotPwdButton addSubview:horizontalLine];
    }
    return _forgotPwdButton;
}

- (UIButton *)loginButton
{
    if (!_loginButton) {
        if (DEVICE_IS_LESS_OR_EQUAL_TO_IPHONE_5) {
            _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(26, self.height-22-30, self.width-26*2, 30)];
        } else {
            _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(26, self.height-22-45, self.width-26*2, 45)];
        }
        [_loginButton setBackgroundColor:[UIColor blackColor]];
        [_loginButton setTitle:@"登 录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginButton.titleLabel setFont:Theme.fontMedium];
        
        _loginButton.clipsToBounds = YES;
        _loginButton.layer.cornerRadius = 2.f;
    }
    return _loginButton;
}


@end
