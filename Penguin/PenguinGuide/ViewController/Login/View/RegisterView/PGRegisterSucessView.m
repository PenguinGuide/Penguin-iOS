//
//  PGRegisterSucessView.m
//  Penguin
//
//  Created by Jing Dai on 7/7/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGRegisterSucessView.h"

@interface PGRegisterSucessView ()

@property (nonatomic, strong, readwrite) UIButton *doneButton;

@end

@implementation PGRegisterSucessView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.logoView removeFromSuperview];
        
        UIImageView *successImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width/2-60, 80, 120, 120)];
        successImageView.image = [UIImage imageNamed:@"pg_login_success"];
        [self addSubview:successImageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, successImageView.bottom+40, self.width, 16)];
        label.font = Theme.fontMedium;
        label.textColor = [UIColor blackColor];
        label.text = @"注 册 成 功";
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        [self addSubview:self.doneButton];
    }
    return self;
}

- (UIButton *)doneButton
{
    if (!_doneButton) {
        if (DEVICE_IS_LESS_OR_EQUAL_TO_IPHONE_5) {
            _doneButton = [[UIButton alloc] initWithFrame:CGRectMake(26, self.height-22-30, self.width-26*2, 30)];
        } else {
            _doneButton = [[UIButton alloc] initWithFrame:CGRectMake(26, self.height-22-45, self.width-26*2, 45)];
        }
        [_doneButton setBackgroundColor:[UIColor blackColor]];
        [_doneButton setTitle:@"完 成" forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_doneButton.titleLabel setFont:Theme.fontMedium];
        
        _doneButton.clipsToBounds = YES;
        _doneButton.layer.cornerRadius = 2.f;
    }
    return _doneButton;
}

@end
