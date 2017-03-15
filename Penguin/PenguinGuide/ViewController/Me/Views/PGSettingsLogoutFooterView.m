//
//  PGSettingsLogoutFooterView.m
//  Penguin
//
//  Created by Jing Dai on 07/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGSettingsLogoutFooterView.h"

@implementation PGSettingsLogoutFooterView

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
    [self addSubview:self.logoutButton];
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openDeveloperPage)];
    tapGesture.numberOfTapsRequired = 7;
    [self addGestureRecognizer:tapGesture];
}

- (void)openDeveloperPage
{
    if (self.openDeveloperPageHandler) {
        self.openDeveloperPageHandler();
    }
}

- (UIButton *)logoutButton
{
    if (!_logoutButton) {
        _logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(38, 28, self.pg_width-38*2, 42)];
        [_logoutButton setTitle:@"退 出 登 录" forState:UIControlStateNormal];
        [_logoutButton setTitleColor:Theme.colorText forState:UIControlStateNormal];
        [_logoutButton.titleLabel setFont:Theme.fontMediumBold];
        _logoutButton.clipsToBounds = YES;
        _logoutButton.layer.cornerRadius = 4.f;
        _logoutButton.layer.borderColor = [UIColor colorWithHexString:@"979797"].CGColor;
        _logoutButton.layer.borderWidth = 1/[UIScreen mainScreen].scale;
    }
    return _logoutButton;
}

@end
