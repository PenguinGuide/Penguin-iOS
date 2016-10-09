//
//  PGRegisterUserInfoView.m
//  Penguin
//
//  Created by Jing Dai on 7/7/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGRegisterUserInfoView.h"

@interface PGRegisterUserInfoView ()

@property (nonatomic, strong, readwrite) UIButton *cameraButton;
@property (nonatomic, strong, readwrite) PGLoginUserInfoTextField *nicknameTextField;
@property (nonatomic, strong, readwrite) PGLoginUserInfoTextField *dateTextField;
@property (nonatomic, strong, readwrite) PGLoginUserInfoTextField *sexTextField;
@property (nonatomic, strong, readwrite) UIButton *nextButton;

@end

@implementation PGRegisterUserInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.logoView removeFromSuperview];
        
        [self addSubview:self.cameraButton];
        [self addSubview:self.nicknameTextField];
        [self addSubview:self.dateTextField];
        [self addSubview:self.sexTextField];
        [self addSubview:self.nextButton];
    }
    return self;
}

- (UIButton *)cameraButton
{
    if (!_cameraButton) {
        _cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(self.pg_width/2-92/2, 34, 92, 92)];
        [_cameraButton setImage:[UIImage imageNamed:@"pg_login_camera"] forState:UIControlStateNormal];
    }
    return _cameraButton;
}

- (PGLoginUserInfoTextField *)nicknameTextField
{
    if (!_nicknameTextField) {
        _nicknameTextField = [[PGLoginUserInfoTextField alloc] initWithFrame:CGRectMake(22, self.cameraButton.pg_bottom+30, self.pg_width-22*2, 46)];
        _nicknameTextField.placeholder = @"请输入昵称";
    }
    return _nicknameTextField;
}

- (PGLoginUserInfoTextField *)dateTextField
{
    if (!_dateTextField) {
        _dateTextField = [[PGLoginUserInfoTextField alloc] initWithFrame:CGRectMake(22, self.nicknameTextField.pg_bottom+10, self.pg_width-22*2, 46)];
        _dateTextField.placeholder = @"选择你的出生年月";
    }
    return _dateTextField;
}

- (PGLoginUserInfoTextField *)sexTextField
{
    if (!_sexTextField) {
        _sexTextField = [[PGLoginUserInfoTextField alloc] initWithFrame:CGRectMake(22, self.dateTextField.pg_bottom+10, self.pg_width-22*2, 46)];
        _sexTextField.placeholder = @"选择你的性别";
    }
    return _sexTextField;
}

- (UIButton *)nextButton
{
    if (!_nextButton) {
        if (DEVICE_IS_LESS_OR_EQUAL_TO_IPHONE_5) {
            _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(26, self.pg_height-22-30, self.pg_width-26*2, 30)];
        } else {
            _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(26, self.pg_height-22-45, self.pg_width-26*2, 45)];
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
