//
//  PGSettingsUpdateViewController.m
//  Penguin
//
//  Created by Jing Dai on 24/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGSettingsUpdateViewController.h"
#import "PGSettingsUpdateTextField.h"

@interface PGSettingsUpdateViewController ()

@property (nonatomic, assign) PGSettingsType settingType;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) PGSettingsUpdateTextField *updateTextField;

@end

@implementation PGSettingsUpdateViewController

- (id)initWithType:(PGSettingsType)setttingType content:(NSString *)content
{
    if (self = [super init]) {
        self.settingType = setttingType;
        self.content = content;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.updateTextField];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveButtonClicked)];
    self.navigationController.navigationBar.tintColor = Theme.colorText;
    self.navigationItem.rightBarButtonItem = saveButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar pg_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.updateTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar pg_reset];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.updateTextField resignFirstResponder];
}

- (void)saveButtonClicked
{
    if (self.updateTextField.text && self.updateTextField.text.length > 0) {
        if (PGGlobal.userId) {
            PGParams *params = [PGParams new];
            
            if (self.settingType == PGSettingsTypeNickname) {
                params[@"nick_name"] = self.updateTextField.text;
            }
            
            [self showLoading];
            
            PGWeakSelf(self);
            
            [self.apiClient pg_makePatchRequest:^(PGRKRequestConfig *config) {
                config.route = PG_User;
                config.params = params;
                config.keyPath = nil;
                config.pattern = @{@"userId":PGGlobal.userId};
            } completion:^(id response) {
                [weakself dismissLoading];
                [weakself.navigationController popToRootViewControllerAnimated:YES];
            } failure:^(NSError *error) {
                [weakself showErrorMessage:error];
                [weakself dismissLoading];
            }];
        } else {
            // TODO: user logout
        }
    }
}

- (PGSettingsUpdateTextField *)updateTextField
{
    if (!_updateTextField) {
        _updateTextField = [[PGSettingsUpdateTextField alloc] initWithFrame:CGRectMake(30, 64+30, UISCREEN_WIDTH-60, 40)];
        switch (self.settingType) {
            case PGSettingsTypeNickname:
                _updateTextField.placeholder = @"点击修改昵称";
                _updateTextField.clearButtonMode = UITextFieldViewModeAlways;
                break;
            case PGSettingsTypeSex:
                _updateTextField.placeholder = @"点击修改性别";
            case PGSettingsTypeLocation:
                _updateTextField.placeholder = @"点击修改城市";
            case PGSettingsTypeBirthday:
                _updateTextField.placeholder = @"点击修改生日";
            case PGSettingsTypePassword:
                _updateTextField.placeholder = @"点击修改密码";
                _updateTextField.secureTextEntry = YES;
                _updateTextField.clearButtonMode = UITextFieldViewModeAlways;
            default:
                break;
        }
        _updateTextField.text = self.content;
    }
    return _updateTextField;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
