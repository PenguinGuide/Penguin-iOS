//
//  PGLoginSMSCodeTextField.m
//  Penguin
//
//  Created by Jing Dai on 7/7/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGLoginSMSCodeTextField.h"

@interface PGLoginSMSCodeTextField ()

@property (nonatomic, strong, readwrite) UIButton *resendButton;

@end

@implementation PGLoginSMSCodeTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.rightViewMode = UITextFieldViewModeAlways;
        self.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 48)];
        [self.rightView addSubview:self.resendButton];
        
        self.leftViewMode = UITextFieldViewModeAlways;
        self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 48)];
        
        self.backgroundColor = [UIColor colorWithHexString:@"e7e7e7"];
        
        self.textColor = [UIColor blackColor];
        self.font = Theme.fontLarge;
        self.secureTextEntry = YES;
        
        self.placeholder = @"请输入验证码";
    }
    return self;
}

- (UIButton *)resendButton
{
    if (!_resendButton) {
        _resendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 48)];
        [_resendButton setTitle:@"重新获取(23)" forState:UIControlStateNormal];
        [_resendButton setTitleColor:[UIColor colorWithHexString:@"ef6733"] forState:UIControlStateNormal];
        [_resendButton.titleLabel setFont:Theme.fontSmall];
    }
    return _resendButton;
}

@end
