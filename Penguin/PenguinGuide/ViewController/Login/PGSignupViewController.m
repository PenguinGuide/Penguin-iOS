//
//  PGSignupViewController.m
//  Penguin
//
//  Created by Jing Dai on 12/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGSignupViewController.h"

#import "PGLoginView.h"
#import "PGLoginSocialView.h"

@interface PGSignupViewController ()

@property (nonatomic, strong) PGLoginView *loginView;
@property (nonatomic, strong) PGLoginSocialView *loginSocialView;

@end

@implementation PGSignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.closeButton.hidden = YES;
    self.backButton.hidden = NO;
    
    [self.loginScrollView addSubview:self.loginView];
    [self.loginScrollView addSubview:self.loginSocialView];
}

#pragma mark - <PGLoginDelegate>

- (void)loginButtonClicked:(UIView *)view
{
    if ([view isKindOfClass:[PGLoginView class]]) {
        
    }
}

#pragma mark - <Setters && Getters>

- (PGLoginView *)loginView
{
    if (!_loginView) {
        _loginView = [[PGLoginView alloc] initWithFrame:CGRectMake(0, self.logoImageView.pg_bottom+45, UISCREEN_WIDTH, UISCREEN_HEIGHT-180-(self.logoImageView.pg_bottom+45))];
        _loginView.delegate = self;
        [_loginView.loginButton setTitle:@"注 册" forState:UIControlStateNormal];
    }
    return _loginView;
}

- (PGLoginSocialView *)loginSocialView
{
    if (!_loginSocialView) {
        _loginSocialView = [[PGLoginSocialView alloc] initWithFrame:CGRectMake(65, UISCREEN_HEIGHT-95, UISCREEN_WIDTH-65*2, 95)];
        _loginSocialView.socialLabel.text = @"使用其他方式注册：";
    }
    return _loginSocialView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
