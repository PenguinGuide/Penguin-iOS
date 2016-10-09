//
//  PGSMSCodeLoginView.m
//  Penguin
//
//  Created by Jing Dai on 7/7/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGSMSCodeLoginView.h"

@interface PGSMSCodeLoginView ()

@property (nonatomic, strong, readwrite) PGLoginPhoneTextField *phoneTextField;
@property (nonatomic, strong, readwrite) PGLoginSMSCodeTextField *smsCodeTextField;
@property (nonatomic, strong, readwrite) UIButton *loginButton;

@end

@implementation PGSMSCodeLoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.phoneTextField];
        [self addSubview:self.smsCodeTextField];
        [self addSubview:self.loginButton];
    }
    return self;
}

- (PGLoginPhoneTextField *)phoneTextField
{
    if (!_phoneTextField) {
        _phoneTextField = [[PGLoginPhoneTextField alloc] initWithFrame:CGRectMake(22, self.logoView.pg_bottom+18, self.pg_width-22*2, 46)];
        _phoneTextField.userInteractionEnabled = NO;
    }
    return _phoneTextField;
}

- (PGLoginSMSCodeTextField *)smsCodeTextField
{
    if (!_smsCodeTextField) {
        _smsCodeTextField = [[PGLoginSMSCodeTextField alloc] initWithFrame:CGRectMake(22, self.phoneTextField.pg_bottom+29, self.pg_width-22*2, 46)];
    }
    return _smsCodeTextField;
}

- (UIButton *)loginButton
{
    if (!_loginButton) {
        if (DEVICE_IS_LESS_OR_EQUAL_TO_IPHONE_5) {
            _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(26, self.pg_height-22-30, self.pg_width-26*2, 30)];
        } else {
            _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(26, self.pg_height-22-45, self.pg_width-26*2, 45)];
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
