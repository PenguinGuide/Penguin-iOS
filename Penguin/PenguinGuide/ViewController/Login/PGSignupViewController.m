//
//  PGSignupViewController.m
//  Penguin
//
//  Created by Jing Dai on 12/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGSignupViewController.h"
#import "PGSignupPwdViewController.h"

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(smsCodeTimerUpdate:) name:PG_NOTIFICATION_SMS_CODE_COUNT_DOWN object:nil];
    
    self.closeButton.hidden = YES;
    self.backButton.hidden = NO;
    
    [self.loginScrollView addSubview:self.loginView];
    [self.loginScrollView addSubview:self.loginSocialView];
    
    if (PGGlobal.smsCodeCountDown > 0) {
        self.loginView.smsCodeButton.userInteractionEnabled = NO;
        [self.loginView.smsCodeButton setTitle:[NSString stringWithFormat:@"重新获取 %@s", @(PGGlobal.smsCodeCountDown)] forState:UIControlStateNormal];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.loginView.phoneTextField resignFirstResponder];
    [self.loginView.smsCodeTextField resignFirstResponder];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - <PGLoginDelegate>

- (void)loginButtonClicked:(UIView *)view
{
    if ([view isKindOfClass:[PGLoginView class]]) {
        PGSignupPwdViewController *pwdVC = [[PGSignupPwdViewController alloc] init];
        pwdVC.phoneNumber = self.loginView.phoneTextField.text;
        pwdVC.smsCode = self.loginView.smsCodeTextField.text;
        [self.navigationController pushViewController:pwdVC animated:YES];
    }
}

- (void)smsCodeButtonClicked:(UIView *)view
{
    if ([view isKindOfClass:[PGLoginView class]]) {
        PGParams *params = [PGParams new];
        params[@"mobile"] = self.loginView.phoneTextField.text;
        
        [self showLoading];
        
        PGWeakSelf(self);
        [self.apiClient pg_makePostRequest:^(PGRKRequestConfig *config) {
            config.route = PG_Send_SMS_Code;
            config.params = params;
            config.keyPath = nil;
        } completion:^(id response) {
            [weakself dismissLoading];
            [weakself showToast:@"发送成功"];
            weakself.loginView.smsCodeButton.userInteractionEnabled = NO;
            PGGlobal.smsCodeCountDown = 60;
            [weakself.loginView.smsCodeButton setTitle:[NSString stringWithFormat:@"重新获取 %@s", @(PGGlobal.smsCodeCountDown)] forState:UIControlStateNormal];
            [PGGlobal resetSMSCodeTimer];
        } failure:^(NSError *error) {
            [weakself showErrorMessage:error];
            [weakself dismissLoading];
        }];
    }
}

- (void)accessoryDoneButtonClicked
{
    [self.loginView.phoneTextField resignFirstResponder];
    [self.loginView.smsCodeTextField resignFirstResponder];
}

#pragma mark - <Notification>

- (void)smsCodeTimerUpdate:(NSNotification *)notification
{
    NSInteger countdown = [notification.object integerValue];
    if (countdown > 0) {
        PGWeakSelf(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            weakself.loginView.smsCodeButton.userInteractionEnabled = NO;
            [weakself.loginView.smsCodeButton setTitle:[NSString stringWithFormat:@"重新获取 %@s", @(PGGlobal.smsCodeCountDown)] forState:UIControlStateNormal];
        });
    } else {
        PGWeakSelf(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            weakself.loginView.smsCodeButton.userInteractionEnabled = YES;
            [weakself.loginView.smsCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        });
    }
}

#pragma mark - <Setters && Getters>

- (PGLoginView *)loginView
{
    if (!_loginView) {
        _loginView = [[PGLoginView alloc] initWithFrame:CGRectMake(0, self.logoImageView.pg_bottom+45, UISCREEN_WIDTH, UISCREEN_HEIGHT-180-(self.logoImageView.pg_bottom+45))];
        _loginView.delegate = self;
        _loginView.phoneTextField.delegate = self;
        _loginView.smsCodeTextField.delegate = self;
        _loginView.phoneTextField.inputAccessoryView = self.accessoryView;
        _loginView.smsCodeTextField.inputAccessoryView = self.accessoryView;
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
