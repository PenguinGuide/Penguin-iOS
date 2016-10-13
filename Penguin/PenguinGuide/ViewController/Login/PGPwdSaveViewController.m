//
//  PGPwdSaveViewController.m
//  Penguin
//
//  Created by Jing Dai on 13/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGPwdSaveViewController.h"

#import "PGPwdSaveView.h"

@interface PGPwdSaveViewController ()

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

- (PGPwdSaveView *)pwdSaveView
{
    if (!_pwdSaveView) {
        _pwdSaveView = [[PGPwdSaveView alloc] initWithFrame:CGRectMake(0, self.logoImageView.pg_bottom+45, UISCREEN_WIDTH, UISCREEN_HEIGHT-180-(self.logoImageView.pg_bottom+45))];
    }
    return _pwdSaveView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
