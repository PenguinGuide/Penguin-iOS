//
//  PGDeveloperViewController.m
//  Penguin
//
//  Created by Jing Dai on 15/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGDeveloperViewController.h"

@interface PGDeveloperViewController ()

@property (nonatomic, strong) UILabel *currentHostLabel;
@property (nonatomic, strong) UIButton *productionHostButton;
@property (nonatomic, strong) UIButton *debugHostButton;

@end

@implementation PGDeveloperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationTitle:@"开发者页面"];
    
    [self.view addSubview:self.currentHostLabel];
    [self.view addSubview:self.productionHostButton];
    [self.view addSubview:self.debugHostButton];
}

#pragma mark - <Button Events>

- (void)productionButtonClicked
{
    [PGGlobal synchronizeHostUrl:@"https://api.penguinguide.cn"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PG_NOTIFICATION_LOGOUT object:nil];
    
    [PGGlobal synchronizeUserId:nil];
    [PGGlobal synchronizeToken:nil];
    [PGShareManager logout];
    
    [PGGlobal.cache deleteObjectForKey:@"apns_token" fromTable:@"Session"];
    
    self.currentHostLabel.text = @"当前环境：生产";
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)debugButtonClicked
{
    [PGGlobal synchronizeHostUrl:@"https://api.penguin.guide"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PG_NOTIFICATION_LOGOUT object:nil];
    
    [PGGlobal synchronizeUserId:nil];
    [PGGlobal synchronizeToken:nil];
    [PGShareManager logout];
    
    [PGGlobal.cache deleteObjectForKey:@"apns_token" fromTable:@"Session"];
    
    self.currentHostLabel.text = @"当前环境：测试";
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - <Lazy Init>

- (UILabel *)currentHostLabel
{
    if (!_currentHostLabel) {
        _currentHostLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 70, UISCREEN_WIDTH-60, 30)];
        _currentHostLabel.textColor = Theme.colorText;
        _currentHostLabel.font = Theme.fontMedium;
        if ([PGGlobal.hostUrl isEqualToString:@"https://api.penguin.guide"]) {
            _currentHostLabel.text = @"当前环境：测试";
        } else if ([PGGlobal.hostUrl isEqualToString:@"https://api.penguinguide.cn"]) {
            _currentHostLabel.text = @"当前环境：生产";
        }
    }
    return _currentHostLabel;
}

- (UIButton *)productionHostButton
{
    if (!_productionHostButton) {
        _productionHostButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 110, 120, 30)];
        [_productionHostButton setTitle:@"切换至生产环境" forState:UIControlStateNormal];
        [_productionHostButton setTitleColor:Theme.colorText forState:UIControlStateNormal];
        [_productionHostButton.titleLabel setFont:Theme.fontMedium];
        [_productionHostButton addTarget:self action:@selector(productionButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        _productionHostButton.clipsToBounds = YES;
        _productionHostButton.layer.borderColor = Theme.colorText.CGColor;
        _productionHostButton.layer.borderWidth = 1/[UIScreen mainScreen].scale;
        _productionHostButton.layer.cornerRadius = 4.f;
    }
    return _productionHostButton;
}

- (UIButton *)debugHostButton
{
    if (!_debugHostButton) {
        _debugHostButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 150, 120, 30)];
        [_debugHostButton setTitle:@"切换至测试环境" forState:UIControlStateNormal];
        [_debugHostButton setTitleColor:Theme.colorText forState:UIControlStateNormal];
        [_debugHostButton.titleLabel setFont:Theme.fontMedium];
        [_debugHostButton addTarget:self action:@selector(debugButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        _debugHostButton.clipsToBounds = YES;
        _debugHostButton.layer.borderColor = Theme.colorText.CGColor;
        _debugHostButton.layer.borderWidth = 1/[UIScreen mainScreen].scale;
        _debugHostButton.layer.cornerRadius = 4.f;
    }
    return _debugHostButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
