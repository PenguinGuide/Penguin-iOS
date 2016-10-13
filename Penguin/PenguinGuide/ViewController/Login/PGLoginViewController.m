//
//  PGLoginViewController.m
//  Penguin
//
//  Created by Jing Dai on 11/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGLoginViewController.h"
#import "PGSignupViewController.h"
#import "PGPwdLoginViewController.h"

#import "PGLoginView.h"
#import "PGLoginSocialView.h"

@interface PGLoginViewController ()

@property (nonatomic, strong) PGLoginView *loginView;
@property (nonatomic, strong) PGLoginSocialView *loginSocialView;
@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) UIButton *pwdLoginButton;

@end

@implementation PGLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.closeButton.hidden = NO;
    self.backButton.hidden = YES;
    
    [self.loginScrollView addSubview:self.loginView];
    [self.loginScrollView addSubview:self.registerButton];
    [self.loginScrollView addSubview:self.pwdLoginButton];
    [self.loginScrollView addSubview:self.loginSocialView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - <PGLoginDelegate>

- (void)loginButtonClicked:(UIView *)view
{
    if ([view isKindOfClass:[PGLoginView class]]) {
        
    }
}

#pragma mark - <Button Events>

- (void)registerButtonClicked
{
    PGSignupViewController *signupVC = [[PGSignupViewController alloc] init];
    [self.navigationController pushViewController:signupVC animated:YES];
}

- (void)pwdLoginButtonClicked
{
    PGPwdLoginViewController *pwdLoginVC = [[PGPwdLoginViewController alloc] init];
    [self.navigationController pushViewController:pwdLoginVC animated:YES];
}

#pragma mark - <Setters && Getters>

- (PGLoginView *)loginView
{
    if (!_loginView) {
        _loginView = [[PGLoginView alloc] initWithFrame:CGRectMake(0, self.logoImageView.pg_bottom+45, UISCREEN_WIDTH, UISCREEN_HEIGHT-180-(self.logoImageView.pg_bottom+45))];
        _loginView.delegate = self;
        [_loginView.loginButton setTitle:@"登 录" forState:UIControlStateNormal];
    }
    return _loginView;
}

- (PGLoginSocialView *)loginSocialView
{
    if (!_loginSocialView) {
        _loginSocialView = [[PGLoginSocialView alloc] initWithFrame:CGRectMake(65, UISCREEN_HEIGHT-95, UISCREEN_WIDTH-65*2, 95)];
        _loginSocialView.socialLabel.text = @"使用其他方式登录：";
    }
    return _loginSocialView;
}

- (UIButton *)registerButton
{
    if (!_registerButton) {
        _registerButton = [[UIButton alloc] initWithFrame:CGRectMake(50, self.loginView.pg_bottom+10, 50, 20)];
        [_registerButton setTitle:@"立即注册" forState:UIControlStateNormal];
        [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_registerButton.titleLabel setFont:Theme.fontExtraSmallBold];
        [_registerButton addTarget:self action:@selector(registerButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

- (UIButton *)pwdLoginButton
{
    if (!_pwdLoginButton) {
        _pwdLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(UISCREEN_WIDTH-50-70, self.loginView.pg_bottom+10, 70, 20)];
        [_pwdLoginButton setTitle:@"使用密码登录" forState:UIControlStateNormal];
        [_pwdLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_pwdLoginButton.titleLabel setFont:Theme.fontExtraSmallBold];
        [_pwdLoginButton addTarget:self action:@selector(pwdLoginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pwdLoginButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
