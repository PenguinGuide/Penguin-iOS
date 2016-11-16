//
//  PGWebViewController.m
//  Penguin
//
//  Created by Jing Dai on 14/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGWebViewController.h"
#import <WebKit/WebKit.h>

@interface PGWebViewController () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *pgWebView;
@property (nonatomic, strong) NSString *requestUrl;
@property (nonatomic, strong) UIView *progressView;

@end

@implementation PGWebViewController

- (id)initWithURL:(NSString *)url
{
    if (self = [super init]) {
        self.requestUrl = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // NOTE: WKWebView: http://www.jianshu.com/p/6ba2507445e4
    [self.view addSubview:self.pgWebView];
    [self.view addSubview:self.progressView];
    
    PGWeakSelf(self);
    [self observe:self.pgWebView keyPath:@"title" block:^(id changedObject) {
        NSString *title = changedObject;
        if (title && [title isKindOfClass:[NSString class]]) {
            [weakself setNavigationTitle:title];
        }
    }];
    [self observe:self.pgWebView keyPath:@"estimatedProgress" block:^(id changedObject) {
        __block float progress = [changedObject floatValue];
        [UIView animateWithDuration:0.4f animations:^{
            weakself.progressView.frame = CGRectMake(-UISCREEN_WIDTH+UISCREEN_WIDTH*progress, 64, UISCREEN_WIDTH, 2);
        }];
    }];
    [self observe:self.pgWebView keyPath:@"loading" block:^(id changedObject) {
        BOOL loading = [changedObject boolValue];
        if (!loading) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakself.progressView.frame = CGRectMake(-UISCREEN_WIDTH, 64, UISCREEN_WIDTH, 2);
            });
        }
    }];
    
    [self.pgWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.requestUrl]]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.progressView removeFromSuperview];
}

- (void)dealloc
{
    [self unobserve];
}

#pragma mark - <WKNavigationDelegate>

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    
}

#pragma mark - <Lazy Init>

- (WKWebView *)pgWebView
{
    if (!_pgWebView) {
        _pgWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        _pgWebView.navigationDelegate = self;
    }
    return _pgWebView;
}

- (UIView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIView alloc] initWithFrame:CGRectMake(-UISCREEN_WIDTH, 64, UISCREEN_WIDTH, 2)];
        _progressView.backgroundColor = Theme.colorHighlight;
    }
    return _progressView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
