//
//  PGContactUsViewController.m
//  Penguin
//
//  Created by Kobe Dai on 12/02/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import "PGContactUsViewController.h"
#import "PGCopyLabel.h"

@interface PGContactUsView : UIView

- (void)setViewWithTitle:(NSString *)title withDesc:(NSString *)desc;

@end

@implementation PGContactUsView

- (void)setViewWithTitle:(NSString *)title withDesc:(NSString *)desc
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, 16)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = Theme.fontMediumBold;
    titleLabel.textColor = Theme.colorText;
    titleLabel.text = title;
    
    PGCopyLabel *descLabel = [[PGCopyLabel alloc] initWithFrame:CGRectMake(0, self.pg_height-16, self.pg_width, 16)];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.font = Theme.fontMediumBold;
    descLabel.textColor = Theme.colorLightText;
    descLabel.text = desc;
    
    [self addSubview:titleLabel];
    [self addSubview:descLabel];
}

@end

@interface PGContactUsViewController ()

@property (nonatomic, strong) PGContactUsView *kefuView;
@property (nonatomic, strong) PGContactUsView *zhushouView;
@property (nonatomic, strong) PGContactUsView *careerView;
@property (nonatomic, strong) UIImageView *footerView;

@end

@implementation PGContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationTitle:@"联系我们"];
    
    [self.view addSubview:self.kefuView];
    [self.view addSubview:self.zhushouView];
    [self.view addSubview:self.careerView];
    [self.view addSubview:self.footerView];
}

- (PGContactUsView *)kefuView
{
    if (!_kefuView) {
        _kefuView = [[PGContactUsView alloc] initWithFrame:CGRectMake(0, 100, self.view.pg_width, 40)];
        [_kefuView setViewWithTitle:@"电商客服微信" withDesc:@"qiekefu"];
    }
    return _kefuView;
}

- (PGContactUsView *)zhushouView
{
    if (!_zhushouView) {
        _zhushouView = [[PGContactUsView alloc] initWithFrame:CGRectMake(0, self.kefuView.pg_bottom+35, self.view.pg_width, 40)];
        [_zhushouView setViewWithTitle:@"吃喝小助手微信" withDesc:@"qiezhushou"];
    }
    return _zhushouView;
}

- (PGContactUsView *)careerView
{
    if (!_careerView) {
        _careerView = [[PGContactUsView alloc] initWithFrame:CGRectMake(0, self.zhushouView.pg_bottom+35, self.view.pg_width, 40)];
        [_careerView setViewWithTitle:@"简历投递" withDesc:@"jobs@penguinguide.cn"];
    }
    return _careerView;
}

- (UIImageView *)footerView
{
    if (!_footerView) {
        _footerView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.pg_width-98)/2, self.view.pg_height-60, 98, 42)];
        _footerView.image = [UIImage imageNamed:@"pg_collection_view_footer_view"];
    }
    return _footerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
