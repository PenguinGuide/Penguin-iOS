//
//  PGPwdLoginViewController.m
//  Penguin
//
//  Created by Jing Dai on 12/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGPwdLoginViewController.h"
#import "PGPwdResetViewController.h"

#import "PGPwdLoginView.h"

@interface PGPwdLoginViewController ()

@property (nonatomic, strong) PGPwdLoginView *pwdLoginView;

@end

@implementation PGPwdLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.closeButton.hidden = YES;
    self.backButton.hidden = NO;
    
    [self.loginScrollView addSubview:self.pwdLoginView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.pwdLoginView.phoneTextField resignFirstResponder];
    [self.pwdLoginView.pwdTextField resignFirstResponder];
}

#pragma mark - <PGLoginDelegate>

- (void)loginButtonClicked:(UIView *)view
{
    if ([view isKindOfClass:[PGPwdLoginView class]]) {
        PGParams *params = [PGParams new];
        params[@"mobile"] = self.pwdLoginView.phoneTextField.text;
        params[@"password"] = self.pwdLoginView.pwdTextField.text;
        
        [self showLoading];
        
        PGWeakSelf(self);
        [self.apiClient pg_makePostRequest:^(PGRKRequestConfig *config) {
            config.route = PG_Phone_Login;
            config.params = params;
            config.keyPath = nil;
        } completion:^(id response) {
            if (response && [response isKindOfClass:[NSDictionary class]]) {
                if (response[@"access_token"]) {
                    NSString *accessToken = response[@"access_token"];
                    if (accessToken && accessToken.length > 0) {
                        [PGGlobal synchronizeToken:accessToken];
                    }
                }
                if (response[@"user_id"]) {
                    NSString *userId = response[@"user_id"];
                    if (userId && userId.length > 0) {
                        [PGGlobal synchronizeUserId:userId];
                    }
                }
            }
            [weakself dismissLoading];
            [weakself dismissViewControllerAnimated:YES completion:nil];
        } failure:^(NSError *error) {
            [weakself dismissLoading];
            [weakself showErrorMessage:error];
        }];
    }
}

- (void)forgotPwdButtonClicked
{
    PGPwdResetViewController *pwdResetVC = [[PGPwdResetViewController alloc] init];
    [self.navigationController pushViewController:pwdResetVC animated:YES];
}

- (void)accessoryDoneButtonClicked
{
    [self.pwdLoginView.phoneTextField resignFirstResponder];
    [self.pwdLoginView.pwdTextField resignFirstResponder];
}

- (PGPwdLoginView *)pwdLoginView
{
    if (!_pwdLoginView) {
        _pwdLoginView = [[PGPwdLoginView alloc] initWithFrame:CGRectMake(0, self.logoImageView.pg_bottom+45, UISCREEN_WIDTH, UISCREEN_HEIGHT-180-(self.logoImageView.pg_bottom+45))];
        _pwdLoginView.delegate = self;
        _pwdLoginView.phoneTextField.delegate = self;
        _pwdLoginView.pwdTextField.delegate = self;
        _pwdLoginView.phoneTextField.inputAccessoryView = self.accessoryView;
        _pwdLoginView.pwdTextField.inputAccessoryView = self.accessoryView;
    }
    return _pwdLoginView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
