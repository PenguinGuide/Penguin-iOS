//
//  PGBaseViewController.m
//  Penguin
//
//  Created by Jing Dai on 7/5/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewController.h"
#import "PGBaseViewController+TransitionAnimation.h"

#import "MBProgressHUD.h"
#import "FLAnimatedImage.h"

@interface PGBaseViewController () <UINavigationControllerDelegate>

@property (nonatomic, strong, readwrite) PGAPIClient *apiClient;
@property (nonatomic, strong, readwrite) FBKVOController *KVOController;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) PGPopupViewController *popupViewController;

@end

@implementation PGBaseViewController

- (id)init
{
    if (self = [super init]) {
        if (PGGlobal.accessToken) {
            [self.apiClient updateAccessToken:[NSString stringWithFormat:@"Bearer %@", PGGlobal.accessToken]];
        } else {
            [self.apiClient updateAccessToken:nil];
        }
    }
    
    return self;
}

- (void)dealloc
{
    [self dismissLoading];
    [self.apiClient cancelAllRequests];
    [self.KVOController unobserve:PGGlobal];
    self.apiClient = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage *backButtonImage = [[UIImage imageNamed:@"pg_navigation_back_button"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(backButtonClicked)];
    // ISSUE: fix left sliding not working, http://blog.csdn.net/meegomeego/article/details/25879605
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    PGWeakSelf(self);
    [self observe:PGGlobal keyPath:@"accessToken" block:^(id changedObject) {
        if (PGGlobal.accessToken) {
            [weakself.apiClient updateAccessToken:[NSString stringWithFormat:@"Bearer %@", PGGlobal.accessToken]];
        } else {
            [weakself.apiClient updateAccessToken:nil];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // http://benscheirman.com/2011/08/when-viewwillappear-isnt-called/
    self.navigationController.delegate = self;
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = [UIColor clearColor];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.navigationController.delegate = nil;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)setNavigationTitle:(NSString *)title
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:Theme.fontMediumBold, NSForegroundColorAttributeName:Theme.colorText}];
    [self.navigationItem setTitle:title];
}

- (void)setTransparentNavigationBar:(UIColor *)tintColor
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault]; // setBackgroundImage will remove _UIBackdropView
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    if (tintColor) {
        [self.navigationController.navigationBar setTintColor:tintColor];
    }
}

- (void)resetTransparentNavigationBar
{
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

#pragma mark - <Back Button>

- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - <KVO Methods>

- (void)observe:(id)object keyPath:(NSString *)keyPath block:(void (^)(id changedObject))block
{
    [self.KVOController observe:object
                        keyPath:keyPath
                        options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew
                          block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
                              if (block) {
                                  block(change[NSKeyValueChangeNewKey]);
                              }
                          }];
}

- (void)unobserve
{
    [self.KVOController unobserveAll];
}

- (void)observeCollectionView:(PGBaseCollectionView *)collectionView endOfFeeds:(PGBaseViewModel *)viewModel
{
    __block PGBaseCollectionView *weakCollectionView = collectionView;
    [self observe:viewModel keyPath:@"endFlag" block:^(id changedObject) {
        BOOL endFlag = [changedObject boolValue];
        if (endFlag) {
            [weakCollectionView disableInfiniteScrolling];
        } else {
            [weakCollectionView enableInfiniteScrolling];
        }
    }];
}

#pragma mark - <Toast>

- (void)showToast:(NSString *)message
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.window showToast:message];
}

- (void)showToast:(NSString *)message position:(PGToastPosition)position
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.window showToast:message position:position];
}

#pragma mark - <Alert>

- (void)showAlert:(NSString *)title message:(NSString *)message actions:(NSArray *)actions style:(void (^)(PGAlertStyle *))styleConfig
{
    PGAlertController *alertController = [PGAlertController alertControllerWithTitle:title message:message style:styleConfig];
    [alertController addActions:actions];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - <Popup>

- (void)showPopup:(UIView *)popupView
{
    self.popupViewController = [PGPopupViewController popupViewControllerWithPopupView:popupView];
    [self presentViewController:self.popupViewController animated:YES completion:nil];
}

- (void)dismissPopup
{
    [self.popupViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <Loading>

- (void)showLoading
{
    if (!self.hud.superview) {
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.frame = CGRectMake(0, 0, 100, 100);
        self.hud.center = CGPointMake(UISCREEN_WIDTH/2, UISCREEN_HEIGHT/2);
        self.hud.margin = 15.f;
        self.hud.mode = MBProgressHUDModeCustomView;
        self.hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        // http://stackoverflow.com/questions/10384207/uiview-shadow-not-working
        self.hud.bezelView.backgroundColor = [UIColor whiteColor];
        self.hud.bezelView.layer.shadowColor = Theme.colorText.CGColor;
        self.hud.bezelView.layer.shadowOffset = CGSizeMake(1.f, 1.f);
        self.hud.bezelView.layer.shadowOpacity = 0.5f;
        self.hud.bezelView.layer.masksToBounds = NO;
        self.hud.userInteractionEnabled = NO;
        
        FLAnimatedImage *animatedImage = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"]]];
        FLAnimatedImageView *animatedImageView = [[FLAnimatedImageView alloc] init];
        animatedImageView.animatedImage = animatedImage;
        self.hud.customView = animatedImageView;
    }
}

- (void)dismissLoading
{
    [self.hud hideAnimated:YES];
}

#pragma mark - <Error Handling>

- (void)observeError:(PGBaseViewModel *)viewModel
{
    PGWeakSelf(self);
    [self observe:viewModel keyPath:@"error" block:^(id changedObject) {
        NSError *error = changedObject;
        if (error && [error isKindOfClass:[NSError class]]) {
            [weakself showErrorMessage:error];
            [weakself dismissLoading];
        }
    }];
}

- (void)showErrorMessage:(NSError *)error
{
    if (error.userInfo) {
        NSDictionary *userInfo = error.userInfo;
        if (userInfo[@"message"]) {
            NSString *errorMsg = userInfo[@"message"];
            if (errorMsg && errorMsg.length > 0) {
                [self showToast:errorMsg position:PGToastPositionTop];
            }
        } else if (userInfo[NSLocalizedDescriptionKey]) {
            [self showToast:userInfo[NSLocalizedDescriptionKey] position:PGToastPositionTop];
        }
    }
    NSInteger errorCode = error.code;
    if (errorCode == 401) {
        [PGRouterManager routeToLoginPage];
    }
}

#pragma mark - <Setters && Getters>

- (PGAPIClient *)apiClient
{
    if (!_apiClient) {
        _apiClient = [PGAPIClient client];
    }
    return _apiClient;
}

- (FBKVOController *)KVOController
{
    if (!_KVOController) {
        _KVOController = [FBKVOController controllerWithObserver:self];
    }
    return _KVOController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
