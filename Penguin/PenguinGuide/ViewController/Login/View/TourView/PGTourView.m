//
//  PGTourView.m
//  Penguin
//
//  Created by Jing Dai on 7/6/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGTourView.h"
#import "PGSocialView.h"

@interface PGTourView () <PGPagedScrollViewDelegate>

@property (nonatomic, strong, readwrite) PGPagedScrollView *pagedScrollView;

@property (nonatomic, strong, readwrite) UIButton *registerButton;
@property (nonatomic, strong, readwrite) UIButton *loginButton;
@property (nonatomic, strong, readwrite) UIButton *closeButton;

@property (nonatomic, strong) PGSocialView *socialView;

@end

@implementation PGTourView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColorWithAlpha:0.9f];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 10.f;

        [self addSubview:self.pagedScrollView];
        if (DEVICE_IS_IPHONE_4) {
            // do nothing
        } else {
            [self addSubview:self.socialView];
        }
        [self addSubview:self.registerButton];
        [self addSubview:self.loginButton];
        [self addSubview:self.closeButton];
        
        [self.pagedScrollView reloadData];
    }
    
    return self;
}

#pragma mark - <PGPagedScrollViewDelegate>

- (NSArray *)imagesForScrollView
{
    return @[@"pg_login_tour_city_guide.gif", @"pg_login_tour_city_guide.gif", @"pg_login_tour_city_guide.gif", @"pg_login_tour_city_guide.gif"];
}

#pragma mark - <Setters && Getters>

- (UIButton *)registerButton
{
    if (!_registerButton) {
        float buttonWidth = (self.frame.size.width-18*2-14)/2;
        if (DEVICE_IS_IPHONE_5) {
            _registerButton = [[UIButton alloc] initWithFrame:CGRectMake(18, self.socialView.pg_top-45, buttonWidth, 30)];
        } else if (DEVICE_IS_IPHONE_4) {
            _registerButton = [[UIButton alloc] initWithFrame:CGRectMake(18, self.frame.size.height-45, buttonWidth, 30)];
        } else {
            _registerButton = [[UIButton alloc] initWithFrame:CGRectMake(18, self.socialView.pg_top-15-45, buttonWidth, 45)];
        }
        _registerButton.clipsToBounds = YES;
        _registerButton.layer.cornerRadius = 2.f;
        [_registerButton setTitle:@"注 册" forState:UIControlStateNormal];
        [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_registerButton setBackgroundColor:[UIColor blackColor]];
        [_registerButton.titleLabel setFont:Theme.fontMedium];
    }
    return _registerButton;
}

- (UIButton *)loginButton
{
    if (!_loginButton) {
        float buttonWidth = (self.frame.size.width-18*2-14)/2;
        if (DEVICE_IS_IPHONE_5) {
            _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(_registerButton.pg_right+14, self.socialView.pg_top-45, buttonWidth, 30)];
        } else if (DEVICE_IS_IPHONE_4) {
            _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(_registerButton.pg_right+14, self.frame.size.height-45, buttonWidth, 30)];
        } else {
            _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(_registerButton.pg_right+14, self.socialView.pg_top-15-45, buttonWidth, 45)];
        }
        _loginButton.clipsToBounds = YES;
        _loginButton.layer.cornerRadius = 2.f;
        [_loginButton setTitle:@"登 录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginButton setBackgroundColor:[UIColor blackColor]];
        [_loginButton.titleLabel setFont:Theme.fontMedium];
    }
    return _loginButton;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-66, 16, 50, 50)];
        _closeButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        _closeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_closeButton setImage:[UIImage imageNamed:@"pg_login_close"] forState:UIControlStateNormal];
    }
    return _closeButton;
}

- (PGPagedScrollView *)pagedScrollView
{
    if (!_pagedScrollView) {
        float width = self.frame.size.width-20*2;
        float height = 190.f/225.f*width+30+15;
        _pagedScrollView = [[PGPagedScrollView alloc] initWithFrame:CGRectMake(20, 60, width, height) imageFillMode:PGPagedScrollViewImageFillModeFit iconMode:PGPagedScrollViewIconModeImageDark];
        _pagedScrollView.delegate = self;
    }
    return _pagedScrollView;
}

- (PGSocialView *)socialView
{
    if (!_socialView) {
        if (DEVICE_IS_LESS_OR_EQUAL_TO_IPHONE_5) {
            _socialView = [[PGSocialView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-11-60, self.frame.size.width, 62)];
        } else {
            _socialView = [[PGSocialView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-11-60-13, self.frame.size.width, 62)];
        }
    }
    return _socialView;
}

@end
