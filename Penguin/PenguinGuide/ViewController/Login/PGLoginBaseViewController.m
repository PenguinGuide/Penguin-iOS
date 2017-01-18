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
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.loginScrollView];
    [self.loginScrollView addSubview:self.bgImageView];
    [self.loginScrollView addSubview:self.logoImageView];
    
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.closeButton];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldHideNavigationBar
{
    return YES;
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

- (void)accessoryDoneButtonClicked
{
    
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
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
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
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        _backButton.hidden = YES;
        [_backButton setImage:[UIImage imageNamed:@"pg_login_back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(UISCREEN_WIDTH-80, 0, 80, 80)];
        _closeButton.hidden = YES;
        [_closeButton setImage:[UIImage imageNamed:@"pg_login_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIView *)accessoryView
{
    if (!_accessoryView) {
        _accessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 44)];
        _accessoryView.backgroundColor = Theme.colorBackground;
        UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(UISCREEN_WIDTH-50, 0, 50, 44)];
        [doneButton addTarget:self action:@selector(accessoryDoneButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [doneButton setTitleColor:Theme.colorText forState:UIControlStateNormal];
        [doneButton setTitle:@"完成" forState:UIControlStateNormal];
        [doneButton.titleLabel setFont:Theme.fontMediumBold];
        [_accessoryView addSubview:doneButton];
    }
    return _accessoryView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
