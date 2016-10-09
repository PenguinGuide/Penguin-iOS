//
//  PGUpdatePasswordView.m
//  Penguin
//
//  Created by Jing Dai on 7/7/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGUpdatePasswordView.h"

@interface PGUpdatePasswordView ()

@property (nonatomic, strong, readwrite) PGLoginPasswordTextField *pwdTextField;
@property (nonatomic, strong, readwrite) UIButton *updatePwdButton;

@end

@implementation PGUpdatePasswordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.pwdTextField];
        [self addSubview:self.updatePwdButton];
    }
    return self;
}

- (PGLoginPasswordTextField *)pwdTextField
{
    if (!_pwdTextField) {
        _pwdTextField = [[PGLoginPasswordTextField alloc] initWithFrame:CGRectMake(22, self.logoView.pg_bottom+18, self.pg_width-22*2, 46)];
    }
    return _pwdTextField;
}

- (UIButton *)updatePwdButton
{
    if (!_updatePwdButton) {
        if (DEVICE_IS_LESS_OR_EQUAL_TO_IPHONE_5) {
            _updatePwdButton = [[UIButton alloc] initWithFrame:CGRectMake(26, self.pg_height-22-30, self.pg_width-26*2, 30)];
        } else {
            _updatePwdButton = [[UIButton alloc] initWithFrame:CGRectMake(26, self.pg_height-22-45, self.pg_width-26*2, 45)];
        }
        [_updatePwdButton setBackgroundColor:[UIColor blackColor]];
        [_updatePwdButton setTitle:@"保 存 新 密 码" forState:UIControlStateNormal];
        [_updatePwdButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_updatePwdButton.titleLabel setFont:Theme.fontMedium];
        
        _updatePwdButton.clipsToBounds = YES;
        _updatePwdButton.layer.cornerRadius = 2.f;
    }
    return _updatePwdButton;
}

@end
