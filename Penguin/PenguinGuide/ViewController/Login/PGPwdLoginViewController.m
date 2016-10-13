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

#pragma mark - <PGLoginDelegate>

- (void)forgotPwdButtonClicked
{
    PGPwdResetViewController *pwdResetVC = [[PGPwdResetViewController alloc] init];
    [self.navigationController pushViewController:pwdResetVC animated:YES];
}

- (PGPwdLoginView *)pwdLoginView
{
    if (!_pwdLoginView) {
        _pwdLoginView = [[PGPwdLoginView alloc] initWithFrame:CGRectMake(0, self.logoImageView.pg_bottom+45, UISCREEN_WIDTH, UISCREEN_HEIGHT-180-(self.logoImageView.pg_bottom+45))];
        _pwdLoginView.delegate = self;
    }
    return _pwdLoginView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
