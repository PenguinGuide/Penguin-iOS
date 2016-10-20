//
//  PGPwdLoginView.m
//  Penguin
//
//  Created by Jing Dai on 12/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGPwdLoginView.h"

@interface PGPwdLoginView ()

@property (nonatomic, strong) UIButton *forgotPwdButton;
@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation PGPwdLoginView

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
    [self addSubview:self.phoneTextField];
    [self addSubview:self.pwdTextField];
    [self addSubview:self.forgotPwdButton];
    [self addSubview:self.loginButton];
}

- (void)loginButtonClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginButtonClicked:)]) {
        [self.delegate loginButtonClicked:self];
    }
}

- (void)forgotPwdButtonClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(forgotPwdButtonClicked)]) {
        [self.delegate forgotPwdButtonClicked];
    }
}

- (PGLoginTextField *)phoneTextField
{
    if (!_phoneTextField) {
        _phoneTextField = [[PGLoginTextField alloc] initWithFrame:CGRectMake(45, 0, self.pg_width-90, 40)];
        _phoneTextField.placeholder = @"请输入手机号";
    }
    return _phoneTextField;
}

- (PGLoginTextField *)pwdTextField
{
    if (!_pwdTextField) {
        _pwdTextField = [[PGLoginTextField alloc] initWithFrame:CGRectMake(45, self.phoneTextField.pg_bottom+10, self.pg_width-90, 40)];
        _pwdTextField.placeholder = @"请输入密码";
    }
    return _pwdTextField;
}

- (UIButton *)forgotPwdButton
{
    if (!_forgotPwdButton) {
        _forgotPwdButton = [[UIButton alloc] initWithFrame:CGRectMake(self.pg_width-45-70, self.pwdTextField.pg_bottom+10, 70, 20)];
        [_forgotPwdButton addTarget:self action:@selector(forgotPwdButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        NSAttributedString *attrS = [[NSAttributedString alloc] initWithString:@"忘记密码?" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"EF6733"],
                                                                                                        NSFontAttributeName:Theme.fontExtraSmallBold,
                                                                                                        NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
        [_forgotPwdButton setAttributedTitle:attrS forState:UIControlStateNormal];
    }
    return _forgotPwdButton;
}

- (UIButton *)loginButton
{
    if (!_loginButton) {
        _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(45, self.pg_height-32, self.pg_width-90, 32)];
        _loginButton.clipsToBounds = YES;
        _loginButton.layer.cornerRadius = 16.f;
        [_loginButton setBackgroundColor:[UIColor whiteColor]];
        [_loginButton setTitle:@"登 录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:Theme.colorText forState:UIControlStateNormal];
        [_loginButton.titleLabel setFont:Theme.fontMediumBold];
        [_loginButton addTarget:self action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

@end
