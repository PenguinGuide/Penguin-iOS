//
//  PGAboutUsViewController.m
//  Penguin
//
//  Created by Kobe Dai on 12/02/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import "PGAboutUsViewController.h"

@interface PGAboutUsViewController ()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) UILabel *copyrightLabel;

@end

@implementation PGAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationTitle:@"关于我们"];
    
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.descLabel];
    [self.view addSubview:self.versionLabel];
    [self.view addSubview:self.copyrightLabel];
}

#pragma mark - <Lazy Init>

- (UIImageView *)logoImageView
{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.pg_width-71)/2, 95, 71, 117)];
        _logoImageView.image = [UIImage imageNamed:@"pg_settings_about_us_logo"];
    }
    return _logoImageView;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.logoImageView.pg_bottom+60, self.view.pg_width, 16)];
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.font = Theme.fontMediumBold;
        _descLabel.textColor = Theme.colorText;
        _descLabel.text = @"/ 你 身 边 最 懂 吃 喝 的 好 朋 友 /";
    }
    return _descLabel;
}

- (UILabel *)versionLabel
{
    if (!_versionLabel) {
        _versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.pg_height-60-20, self.view.pg_width, 20)];
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        _versionLabel.font = Theme.fontMediumBold;
        _versionLabel.textColor = Theme.colorText;
        _versionLabel.text = [NSString stringWithFormat:@"V %@", [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    }
    return _versionLabel;
}

- (UILabel *)copyrightLabel
{
    if (!_copyrightLabel) {
        _copyrightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.versionLabel.pg_bottom+20, self.view.pg_width, 12)];
        _copyrightLabel.textAlignment = NSTextAlignmentCenter;
        _copyrightLabel.font = Theme.fontExtraSmallBold;
        _copyrightLabel.textColor = Theme.colorText;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy"];
        NSString *currentYear = [formatter stringFromDate:[NSDate date]];
        _copyrightLabel.text = [NSString stringWithFormat:@"Copyright ©Penguin Guide (%@) All Rights Reserved", currentYear];
    }
    return _copyrightLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
