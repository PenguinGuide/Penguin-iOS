//
//  PGSMSCodeRegisterView.m
//  Penguin
//
//  Created by Jing Dai on 7/7/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGSMSCodeRegisterView.h"

@interface PGSMSCodeRegisterView ()

@property (nonatomic, strong, readwrite) PGLoginPhoneTextField *phoneTextField;
@property (nonatomic, strong, readwrite) PGLoginSMSCodeTextField *smsCodeTextField;
@property (nonatomic, strong, readwrite) UIButton *nextButton;

@end

@implementation PGSMSCodeRegisterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.phoneTextField];
        [self addSubview:self.smsCodeTextField];
        [self addSubview:self.nextButton];
    }
    return self;
}

- (PGLoginPhoneTextField *)phoneTextField
{
    if (!_phoneTextField) {
        _phoneTextField = [[PGLoginPhoneTextField alloc] initWithFrame:CGRectMake(22, self.logoView.bottom+18, self.width-22*2, 46)];
        _phoneTextField.userInteractionEnabled = NO;
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
