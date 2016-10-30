//
//  PGPwdSaveViewController.m
//  Penguin
//
//  Created by Jing Dai on 13/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGPwdSaveViewController.h"

#import "PGPwdSaveView.h"

@interface PGPwdSaveViewController () <PGLoginDelegate>

@property (nonatomic, strong) PGPwdSaveView *pwdSaveView;

@end

@implementation PGPwdSaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.closeButton.hidden = YES;
    self.backButton.hidden = NO;
    
    [self.loginScrollView addSubview:self.pwdSaveView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.pwdSaveView.newPwdTextField resignFirstResponder];
}

#pragma mark - <PGLoginDelegate>

- (void)setPwdButtonClicked:(UIView *)view
{
    if ([view isKindOfClass:[PGPwdSaveView class]]) {
        PGParams *params = [PGParams new];
        params[@"mobile"] = self.phoneNumber;
        params[@"validation_code"] = self.smsCode;
        params[@"password"] = self.pwdSaveView.newPwdTextField.text;
        
        [self showLoading];
        
        PGWeakSelf(self);
        [self.apiClient pg_makePostRequest:^(PGRKRequestConfig *config) {
            config.route = PG_Reset_Pwd;
            config.params = params;
            config.keyPath = nil;
        } completion:^(id response) {
            [weakself showToast:@"设置成功"];
            [weakself dismissLoading];
            [weakself.navigationController popToRootViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [weakself dismissLoading];
            [weakself showErrorMessage:error];
        }];
    }
}

- (void)accessoryDoneButtonClicked
{
    [self.pwdSaveView.newPwdTextField resignFirstResponder];
}

- (PGPwdSaveView *)pwdSaveView
{
    if (!_pwdSaveView) {
        _pwdSaveView = [[PGPwdSaveView alloc] initWithFrame:CGRectMake(0, self.logoImageView.pg_bottom+45, UISCREEN_WIDTH, UISCREEN_HEIGHT-180-(self.logoImageView.pg_bottom+45))];
        _pwdSaveView.delegate = self;
        _pwdSaveView.newPwdTextField.delegate = self;
        _pwdSaveView.newPwdTextField.placeholder = @"请输入新密码";
        _pwdSaveView.newPwdTextField.inputAccessoryView = self.accessoryView;
        [_pwdSaveView.saveButton setTitle:@"保 存 新 密 码" forState:UIControlStateNormal];
    }
    return _pwdSaveView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
