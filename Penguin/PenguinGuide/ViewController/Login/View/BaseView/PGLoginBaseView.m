//
//  PGLoginBaseView.m
//  Penguin
//
//  Created by Jing Dai on 7/6/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGLoginBaseView.h"

@interface PGLoginBaseView ()

@property (nonatomic, strong, readwrite) UIButton *backButton;
@property (nonatomic, strong, readwrite) UIImageView *logoView;

@end

@implementation PGLoginBaseView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColorWithAlpha:0.9f];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 10.f;
        
        [self addSubview:self.backButton];
        [self addSubview:self.logoView];
    }
    
    return self;
}

- (void)backButtonClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(backButtonClicked:)]) {
        [self.delegate backButtonClicked:self];
    }
}

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 21, 50, 50)];
        _backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _backButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        [_backButton setImage:[UIImage imageNamed:@"pg_login_back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIImageView *)logoView
{
    if (!_logoView) {
        _logoView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-59.f/2, 59, 55, 66)];
        _logoView.image = [UIImage imageNamed:@"pg_login_logo"];
        [self addSubview:_logoView];
    }
    return _logoView;
}

@end
