//
//  PGPrivacyViewController.m
//  Penguin
//
//  Created by Kobe Dai on 22/02/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import "PGPrivacyViewController.h"
#import <WebKit/WebKit.h>

@interface PGPrivacyViewController () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *pgWebView;

@end

@implementation PGPrivacyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationTitle:@"用户协议"];
    
    [self.view addSubview:self.pgWebView];
    
    [self.pgWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://api.penguinguide.cn/static/user_agreement.txt"]]];
}

- (WKWebView *)pgWebView
{
    if (!_pgWebView) {
        _pgWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        _pgWebView.navigationDelegate = self;
    }
    return _pgWebView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
