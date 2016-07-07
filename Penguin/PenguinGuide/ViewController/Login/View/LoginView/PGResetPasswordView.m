//
//  PGResetPasswordView.m
//  Penguin
//
//  Created by Jing Dai on 7/7/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGResetPasswordView.h"

@interface PGResetPasswordView ()

@property (nonatomic, strong, readwrite) PGLoginPhoneTextField *phoneTextField;
@property (nonatomic, strong, readwrite) PGLoginSMSCodeTextField *smsCodeTextField;
@property (nonatomic, strong, readwrite) UIButton *resetPwdButton;

@end

@implementation PGResetPasswordView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.phoneTextField];
        [self addSubview:self.smsCodeTextField];
        [self addSubview:self.resetPwdButton];
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

- (PGLoginSMSCodeTextField *)smsCodeTextField
{
    if (!_smsCodeTextField) {
        _smsCodeTextField = [[PGLoginSMSCodeTextField alloc] initWithFrame:CGRectMake(22, self.phoneTextField.bottom+29, self.width-22*2, 46)];
    }
    return _smsCodeTextField;
}

- (UIButton *)resetPwdButton
{
    if (!_resetPwdButton) {
        if (DEVICE_IS_LESS_OR_EQUAL_TO_IPHONE_5) {
            _resetPwdButton = [[UIButton alloc] initWithFrame:CGRectMake(26, self.height-22-30, self.width-26*2, 30)];
        } else {
            _resetPwdButton = [[UIButton alloc] initWithFrame:CGRectMake(26, self.height-22-45, self.width-26*2, 45)];
        }
        [_resetPwdButton setBackgroundColor:[UIColor blackColor]];
        [_resetPwdButton setTitle:@"重 置 密 码" forState:UIControlStateNormal];
        [_resetPwdButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_resetPwdButton.titleLabel setFont:Theme.fontMedium];
        
        _resetPwdButton.clipsToBounds = YES;
        _resetPwdButton.layer.cornerRadius = 2.f;
    }
    return _resetPwdButton;
}

@end
