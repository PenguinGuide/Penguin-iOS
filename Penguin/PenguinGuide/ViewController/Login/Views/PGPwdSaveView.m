//
//  PGPwdSaveView.m
//  Penguin
//
//  Created by Jing Dai on 13/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGPwdSaveView.h"

@interface PGPwdSaveView ()

@end

@implementation PGPwdSaveView

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
    [self addSubview:self.newPwdTextField];
    [self addSubview:self.saveButton];
}

- (void)saveButtonClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(setPwdButtonClicked:)]) {
        [self.delegate setPwdButtonClicked:self];
    }
}

- (PGLoginTextField *)newPwdTextField
{
    if (!_newPwdTextField) {
        _newPwdTextField = [[PGLoginTextField alloc] initWithFrame:CGRectMake(45, 0, self.pg_width-90, 40)];
    }
    return _newPwdTextField;
}

- (UIButton *)saveButton
{
    if (!_saveButton) {
        _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(45, self.pg_height-32, self.pg_width-90, 32)];
        _saveButton.clipsToBounds = YES;
        _saveButton.layer.cornerRadius = 16.f;
        [_saveButton setBackgroundColor:[UIColor whiteColor]];
        [_saveButton setTitleColor:Theme.colorText forState:UIControlStateNormal];
        [_saveButton.titleLabel setFont:Theme.fontMediumBold];
        [_saveButton addTarget:self action:@selector(saveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

@end
