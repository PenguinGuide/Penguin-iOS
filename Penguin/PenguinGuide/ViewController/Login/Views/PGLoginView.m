//
//  PGLoginView.m
//  Penguin
//
//  Created by Jing Dai on 11/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGLoginView.h"
#import "PGLoginTextField.h"
#import "PGSMSCodeButton.h"

@interface PGLoginView ()

@property (nonatomic, strong) PGSMSCodeButton *smsCodeButton;
@property (nonatomic, strong) PGLoginTextField *phoneTextField;
@property (nonatomic, strong) PGLoginTextField *smsCodeTextField;

@end

@implementation PGLoginView

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
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.smsCodeButton];
    [self addSubview:self.phoneTextField];
    [self addSubview:self.smsCodeTextField];
    [self addSubview:self.loginButton];
}

- (void)loginButtonClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginButtonClicked:)]) {
        [self.delegate loginButtonClicked:self];
    }
}

- (PGSMSCodeButton *)smsCodeButton
{
    if (!_smsCodeButton) {
        _smsCodeButton = [[PGSMSCodeButton alloc] initWithFrame:CGRectMake(self.pg_width-45-100, 0, 100, 40)];
    }
    return _smsCodeButton;
}

- (PGLoginTextField *)phoneTextField
{
    if (!_phoneTextField) {
        _phoneTextField = [[PGLoginTextField alloc] initWithFrame:CGRectMake(45, 0, self.pg_width-90-100-10, 40)];
        _phoneTextField.placeholder = @"请输入手机号";
    }
    return _phoneTextField;
}

- (PGLoginTextField *)smsCodeTextField
{
    if (!_smsCodeTextField) {
        _smsCodeTextField = [[PGLoginTextField alloc] initWithFrame:CGRectMake(45, self.phoneTextField.pg_bottom+10, self.pg_width-90, 40)];
        _smsCodeTextField.placeholder = @"请输入验证码";
    }
    return _smsCodeTextField;
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
