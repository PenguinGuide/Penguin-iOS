//
//  PGLoginBaseViewController.m
//  Penguin
//
//  Created by Jing Dai on 12/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGLoginBaseViewController.h"

@interface PGLoginBaseViewController ()

@property (nonatomic, strong) UIImageView *bgImageView;

@end

@implementation PGLoginBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.loginScrollView];
    [self.loginScrollView addSubview:self.bgImageView];
    [self.loginScrollView addSubview:self.logoImageView];
    
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.closeButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    __block CGRect beginFrame = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    __block CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    float duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    PGWeakSelf(self);
    [UIView animateWithDuration:duration
                     animations:^{
                         if (endFrame.origin.y <= beginFrame.origin.y) {
                             weakself.loginScrollView.contentOffset = CGPointMake(weakself.loginScrollView.contentOffset.x, weakself.loginScrollView.contentOffset.y+(beginFrame.origin.y-endFrame.origin.y)/2);
                         } else {
                             weakself.loginScrollView.contentOffset = CGPointMake(weakself.loginScrollView.contentOffset.x, 0);
                         }
                     }];
}

#pragma mark - <Button Events>

- (void)closeButtonClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <Setters && Getters>

- (UIScrollView *)loginScrollView
{
    if (!_loginScrollView) {
        _loginScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _loginScrollView.contentSize = CGSizeMake(UISCREEN_WIDTH, UISCREEN_HEIGHT);
        _loginScrollView.backgroundColor = [UIColor clearColor];
    }
    return _loginScrollView;
}

- (UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT)];
        _bgImageView.image = [UIImage imageNamed:@"pg_login_bg"];
    }
    return _bgImageView;
}

- (UIImageView *)logoImageView
{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((UISCREEN_WIDTH-224)/2, 65, 224, 92)];
        _logoImageView.image = [UIImage imageNamed:@"pg_login_logo"];
    }
    return _logoImageView;
}

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(24, 25, 50, 50)];
        _backButton.hidden = YES;
        [_backButton setImage:[UIImage imageNamed:@"pg_login_back"] forState:UIControlStateNormal];
        [_backButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [_backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(UISCREEN_WIDTH-24-50, 25, 50, 50)];
        _closeButton.hidden = YES;
        [_closeButton setImage:[UIImage imageNamed:@"pg_login_close"] forState:UIControlStateNormal];
        [_closeButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [_closeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [_closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
