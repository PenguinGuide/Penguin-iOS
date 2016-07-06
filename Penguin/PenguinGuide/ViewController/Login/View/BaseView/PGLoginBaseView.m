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

@end

@implementation PGLoginBaseView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColorWithAlpha:0.9f];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 10.f;
        
        UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2-59.f/2, 59, 55, 66)];
        logoView.image = [UIImage imageNamed:@"pg_login_logo"];
        [self addSubview:logoView];
        
        [self addSubview:self.backButton];
    }
    
    return self;
}

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 21, 50, 50)];
        _backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _backButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        [_backButton setImage:[UIImage imageNamed:@"pg_login_back"] forState:UIControlStateNormal];
    }
    return _backButton;
}

@end
