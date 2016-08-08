//
//  PGLoginViewController.m
//  Penguin
//
//  Created by Jing Dai on 7/6/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGLoginViewController.h"
// tour
#import "PGTourView.h"
// login
#import "PGLoginView.h"
#import "PGSMSCodeLoginView.h"
#import "PGPasswordLoginView.h"
#import "PGResetPasswordView.h"
#import "PGUpdatePasswordView.h"
// register
#import "PGRegisterView.h"
#import "PGSMSCodeRegisterView.h"
#import "PGRegisterUserInfoView.h"
#import "PGRegisterSucessView.h"

@interface PGLoginViewController () <PGLoginViewDelegate>

@property (nonatomic) BOOL shouldHideStatusBar;

@property (nonatomic, strong) UIImage *screenshot;
@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) NSMutableArray *viewsStack;
// tour
@property (nonatomic, strong) PGTourView *tourView;
// login
@property (nonatomic, strong) PGLoginView *loginView;
@property (nonatomic, strong) PGSMSCodeLoginView *smsCodeLoginView;
@property (nonatomic, strong) PGPasswordLoginView *pwdLoginView;
@property (nonatomic, strong) PGResetPasswordView *resetPwdView;
@property (nonatomic, strong) PGUpdatePasswordView *updatePwdView;
// reigster
@property (nonatomic, strong) PGRegisterView *registerView;
@property (nonatomic, strong) PGSMSCodeRegisterView *smsCodeRegisterView;
@property (nonatomic, strong) PGRegisterUserInfoView *registerUserInfoView;
@property (nonatomic, strong) PGRegisterSucessView *registerSuccessView;

@end

@implementation PGLoginViewController

- (id)initWithScreenshot:(UIImage *)screenshot
{
    if (self = [super init]) {
        self.screenshot = screenshot;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.pageView = @"登录页面";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.tourView];
    
    self.shouldHideStatusBar = YES;
    
    [self.viewsStack addObject:self.tourView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (BOOL)prefersStatusBarHidden
{
    return self.shouldHideStatusBar;
}

#pragma mark - <PGTourView>

- (void)tourViewLoginButtonClicked
{
    [self.view addSubview:self.loginView];
    
    [self transitCurrentView:self.tourView toNextView:self.loginView];
}

- (void)tourViewRegisterButtonClicked
{
    [self.view addSubview:self.registerView];
    
    [self transitCurrentView:self.tourView toNextView:self.registerView];
}

- (void)tourViewCloseButtonClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <PGLoginView>

- (void)loginViewNextButtonClicked
{
    [self.view addSubview:self.smsCodeLoginView];
    
    [self transitCurrentView:self.loginView toNextView:self.smsCodeLoginView];
}

- (void)loginViewPwdLoginButtonClicked
{
    [self.view addSubview:self.pwdLoginView];
    
    [self transitCurrentView:self.loginView toNextView:self.pwdLoginView];
}

#pragma mark - <PGPasswordLoginView>

- (void)passwordLoginViewForgotPwdButtonClicked
{
    [self.view addSubview:self.resetPwdView];
    
    [self transitCurrentView:self.pwdLoginView toNextView:self.resetPwdView];
}

#pragma mark - <PGResetPasswordView>

- (void)resetPasswordViewResetButtonClicked
{
    [self.view addSubview:self.updatePwdView];
    
    [self transitCurrentView:self.resetPwdView toNextView:self.updatePwdView];
}

#pragma mark - <PGRegisterView>

- (void)registerViewNextButtonClicked
{
    [self.view addSubview:self.smsCodeRegisterView];
    
    [self transitCurrentView:self.registerView toNextView:self.smsCodeRegisterView];
}

#pragma mark - <PGSMSCodeRegisterView>

- (void)smsCodeRegisterViewNextButtonClicked
{
    [self.view addSubview:self.registerUserInfoView];
    
    [self transitCurrentView:self.smsCodeRegisterView toNextView:self.registerUserInfoView];
}

#pragma mark - <PGRegisterUserInfoView>

- (void)registerUserInfoViewNextButtonClicked
{
    [self.view addSubview:self.registerSuccessView];
    
    [self transitCurrentView:self.registerUserInfoView toNextView:self.registerSuccessView];
}

#pragma mark - <PGRegisterSucessView>

- (void)registerSuccessViewDoneButtonClicked
{
    
}

#pragma mark - <View Transition Methods>

- (void)transitCurrentView:(UIView *)currentView toNextView:(UIView *)nextView
{
    [self.viewsStack addObject:nextView];
    
    CGRect currentViewFrame = currentView.frame;
    CGRect nextViewFrame = nextView.frame;
    
    [UIView animateWithDuration:0.5f
                          delay:0.f
         usingSpringWithDamping:0.7f
          initialSpringVelocity:0.7f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         currentView.frame = CGRectMake(currentViewFrame.origin.x-UISCREEN_WIDTH, currentViewFrame.origin.y, currentViewFrame.size.width, currentViewFrame.size.height);
                         nextView.frame = CGRectMake((UISCREEN_WIDTH-nextViewFrame.size.width)/2, (UISCREEN_HEIGHT-nextViewFrame.size.height)/2, nextViewFrame.size.width, nextViewFrame.size.height);
                     } completion:^(BOOL finished) {
                         [currentView removeFromSuperview];
                     }];
}

- (void)transitCurrentView:(UIView *)currentView toPreviousView:(UIView *)previousView
{
    [self.viewsStack removeLastObject];
    
    CGRect currentViewFrame = currentView.frame;
    CGRect previousViewFrame = previousView.frame;
    
    [UIView animateWithDuration:0.5f
                          delay:0.f
         usingSpringWithDamping:0.7f
          initialSpringVelocity:0.7f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         currentView.frame = CGRectMake(currentViewFrame.origin.x+UISCREEN_WIDTH, currentViewFrame.origin.y, currentViewFrame.size.width, currentViewFrame.size.height);
                         previousView.frame = CGRectMake((UISCREEN_WIDTH-previousViewFrame.size.width)/2, (UISCREEN_HEIGHT-previousViewFrame.size.height)/2, previousViewFrame.size.width, previousViewFrame.size.height);
                     } completion:^(BOOL finished) {
                         [currentView removeFromSuperview];
                     }];
}

#pragma mark - <PGLoginViewDelegate>

- (void)backButtonClicked:(PGLoginBaseView *)view
{
    if (self.viewsStack.count >= 2) {
        UIView *currentView = [self.viewsStack lastObject];
        UIView *previousView = self.viewsStack[self.viewsStack.count-2];
        
        if ([currentView isKindOfClass:[PGLoginBaseView class]]) {
            [self.view addSubview:previousView];
            [self transitCurrentView:currentView toPreviousView:previousView];
        }
    }
}

#pragma mark - <Setters && Getters>

- (UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        if (self.screenshot) {
            UIImage *blurredImage = [self.screenshot applyBlurEffectWithRadius:5 tintColor:[UIColor whiteColorWithAlpha:0.1f] saturationDeltaFactor:1 maskImage:nil];
            _bgImageView.image = blurredImage;
        } else {
            UIImage *blurredImage = [[UIImage imageNamed:@"pg_login_bg"] applyBlurEffectWithRadius:5 tintColor:[UIColor whiteColorWithAlpha:0.1f] saturationDeltaFactor:1 maskImage:nil];
            _bgImageView.image = blurredImage;
        }
    }
    
    return _bgImageView;
}

- (PGTourView *)tourView
{
    if (!_tourView) {
        float width = 260.f * (UISCREEN_WIDTH/320);
        float height = 420.f * (UISCREEN_HEIGHT/568);
        _tourView = [[PGTourView alloc] initWithFrame:CGRectMake((UISCREEN_WIDTH-width)/2, (UISCREEN_HEIGHT-height)/2, width, height)];
        
        [_tourView.loginButton addTarget:self action:@selector(tourViewLoginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_tourView.registerButton addTarget:self action:@selector(tourViewRegisterButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_tourView.closeButton addTarget:self action:@selector(tourViewCloseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _tourView;
}

- (PGLoginView *)loginView
{
    if (!_loginView) {
        float width = 260.f * (UISCREEN_WIDTH/320);
        float height = 420.f * (UISCREEN_HEIGHT/568);
        _loginView = [[PGLoginView alloc] initWithFrame:CGRectMake((UISCREEN_WIDTH-width)/2+UISCREEN_WIDTH, (UISCREEN_HEIGHT-height)/2, width, height)];
        _loginView.delegate = self;
        
        [_loginView.nextButton addTarget:self action:@selector(loginViewNextButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_loginView.pwdLoginButton addTarget:self action:@selector(loginViewPwdLoginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginView;
}

- (PGSMSCodeLoginView *)smsCodeLoginView
{
    if (!_smsCodeLoginView) {
        float width = 260.f * (UISCREEN_WIDTH/320);
        float height = 420.f * (UISCREEN_HEIGHT/568);
        _smsCodeLoginView = [[PGSMSCodeLoginView alloc] initWithFrame:CGRectMake((UISCREEN_WIDTH-width)/2+UISCREEN_WIDTH, (UISCREEN_HEIGHT-height)/2, width, height)];
        _smsCodeLoginView.delegate = self;
    }
    return _smsCodeLoginView;
}

- (PGPasswordLoginView *)pwdLoginView
{
    if (!_pwdLoginView) {
        float width = 260.f * (UISCREEN_WIDTH/320);
        float height = 420.f * (UISCREEN_HEIGHT/568);
        _pwdLoginView = [[PGPasswordLoginView alloc] initWithFrame:CGRectMake((UISCREEN_WIDTH-width)/2+UISCREEN_WIDTH, (UISCREEN_HEIGHT-height)/2, width, height)];
        _pwdLoginView.delegate = self;
        
        [_pwdLoginView.forgotPwdButton addTarget:self action:@selector(passwordLoginViewForgotPwdButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pwdLoginView;
}

- (PGResetPasswordView *)resetPwdView
{
    if (!_resetPwdView) {
        float width = 260.f * (UISCREEN_WIDTH/320);
        float height = 420.f * (UISCREEN_HEIGHT/568);
        _resetPwdView = [[PGResetPasswordView alloc] initWithFrame:CGRectMake((UISCREEN_WIDTH-width)/2+UISCREEN_WIDTH, (UISCREEN_HEIGHT-height)/2, width, height)];
        _resetPwdView.delegate = self;
        
        [_resetPwdView.resetPwdButton addTarget:self action:@selector(resetPasswordViewResetButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetPwdView;
}

- (PGUpdatePasswordView *)updatePwdView
{
    if (!_updatePwdView) {
        float width = 260.f * (UISCREEN_WIDTH/320);
        float height = 420.f * (UISCREEN_HEIGHT/568);
        _updatePwdView = [[PGUpdatePasswordView alloc] initWithFrame:CGRectMake((UISCREEN_WIDTH-width)/2+UISCREEN_WIDTH, (UISCREEN_HEIGHT-height)/2, width, height)];
        _updatePwdView.delegate = self;
    }
    return _updatePwdView;
}

- (PGRegisterView *)registerView
{
    if (!_registerView) {
        float width = 260.f * (UISCREEN_WIDTH/320);
        float height = 420.f * (UISCREEN_HEIGHT/568);
        _registerView = [[PGRegisterView alloc] initWithFrame:CGRectMake((UISCREEN_WIDTH-width)/2+UISCREEN_WIDTH, (UISCREEN_HEIGHT-height)/2, width, height)];
        _registerView.delegate = self;
        
        [_registerView.nextButton addTarget:self action:@selector(registerViewNextButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerView;
}

- (PGSMSCodeRegisterView *)smsCodeRegisterView
{
    if (!_smsCodeRegisterView) {
        float width = 260.f * (UISCREEN_WIDTH/320);
        float height = 420.f * (UISCREEN_HEIGHT/568);
        _smsCodeRegisterView = [[PGSMSCodeRegisterView alloc] initWithFrame:CGRectMake((UISCREEN_WIDTH-width)/2+UISCREEN_WIDTH, (UISCREEN_HEIGHT-height)/2, width, height)];
        _smsCodeRegisterView.delegate = self;
        
        [_smsCodeRegisterView.nextButton addTarget:self action:@selector(smsCodeRegisterViewNextButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _smsCodeRegisterView;
}

- (PGRegisterUserInfoView *)registerUserInfoView
{
    if (!_registerUserInfoView) {
        float width = 260.f * (UISCREEN_WIDTH/320);
        float height = 420.f * (UISCREEN_HEIGHT/568);
        _registerUserInfoView = [[PGRegisterUserInfoView alloc] initWithFrame:CGRectMake((UISCREEN_WIDTH-width)/2+UISCREEN_WIDTH, (UISCREEN_HEIGHT-height)/2, width, height)];
        _registerUserInfoView.delegate = self;
        
        [_registerUserInfoView.nextButton addTarget:self action:@selector(registerUserInfoViewNextButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerUserInfoView;
}

- (PGRegisterSucessView *)registerSuccessView
{
    if (!_registerSuccessView) {
        float width = 260.f * (UISCREEN_WIDTH/320);
        float height = 420.f * (UISCREEN_HEIGHT/568);
        _registerSuccessView = [[PGRegisterSucessView alloc] initWithFrame:CGRectMake((UISCREEN_WIDTH-width)/2+UISCREEN_WIDTH, (UISCREEN_HEIGHT-height)/2, width, height)];
        _registerSuccessView.delegate = self;
        
        [_registerSuccessView.doneButton addTarget:self action:@selector(registerSuccessViewDoneButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerSuccessView;
}

- (NSMutableArray *)viewsStack
{
    if (!_viewsStack) {
        _viewsStack = [NSMutableArray new];
    }
    return _viewsStack;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
