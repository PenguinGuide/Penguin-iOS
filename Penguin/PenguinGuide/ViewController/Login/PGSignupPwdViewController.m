//
//  PGSignupPwdViewController.m
//  Penguin
//
//  Created by Jing Dai on 17/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGSignupPwdViewController.h"
#import "PGSignupInfoViewController.h"
#import "PGPwdSaveView.h"

@interface PGSignupPwdViewController () <PGLoginDelegate>

@property (nonatomic, strong) PGPwdSaveView *pwdView;

@end

@implementation PGSignupPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.closeButton.hidden = YES;
    self.backButton.hidden = NO;
    
    [self.loginScrollView addSubview:self.pwdView];
}

#pragma mark - <PGLoginDelegate>

- (void)setPwdButtonClicked:(UIView *)view
{
    if ([view isKindOfClass:[PGPwdSaveView class]]) {
        PGParams *params = [PGParams new];
        params[@"mobile"] = self.phoneNumber;
        params[@"validation_code"] = self.smsCode;
        params[@"password"] = self.pwdView.newPwdTextField.text;
        
        [self showLoading];
        
        PGWeakSelf(self);
        [self.apiClient pg_makePostRequest:^(PGRKRequestConfig *config) {
            config.route = PG_Phone_Register;
            config.params = params;
            config.keyPath = nil;
        } completion:^(id response) {
            if (response && [response isKindOfClass:[NSDictionary class]]) {
                if (response[@"access_token"]) {
                    NSString *accessToken = response[@"access_token"];
                    if (accessToken && accessToken.length > 0) {
                        [PGGlobal synchronizeToken:accessToken];
                        [weakself.apiClient updateAccessToken:accessToken];
                    }
                }
                if (response[@"user_id"]) {
                    NSString *userId = response[@"user_id"];
                    if (userId && userId.length > 0) {
                        [PGGlobal synchronizeUserId:userId];
                    }
                }
                if (response[@"is_new_user"] && [response[@"is_new_user"] boolValue] && PGGlobal.userId) {
                    PGSignupInfoViewController *signupInfoVC = [[PGSignupInfoViewController alloc] init];
                    signupInfoVC.userId = PGGlobal.userId;
                    [weakself.navigationController pushViewController:signupInfoVC animated:YES];
                } else {
                    [weakself dismissViewControllerAnimated:YES completion:nil];
                }
            }
            [weakself dismissLoading];
        } failure:^(NSError *error) {
            [weakself dismissLoading];
            [weakself showErrorMessage:error];
        }];
    }
}

- (PGPwdSaveView *)pwdView
{
    if (!_pwdView) {
        _pwdView = [[PGPwdSaveView alloc] initWithFrame:CGRectMake(0, self.logoImageView.pg_bottom+45, UISCREEN_WIDTH, UISCREEN_HEIGHT-180-(self.logoImageView.pg_bottom+45))];
        _pwdView.delegate = self;
        _pwdView.newPwdTextField.delegate = self;
        _pwdView.newPwdTextField.placeholder = @"请输入密码";
        [_pwdView.saveButton setTitle:@"完 成" forState:UIControlStateNormal];
    }
    return _pwdView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
