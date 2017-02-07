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

#import "PGPageBasePlaceholder.h"

@interface PGBaseViewController () <UINavigationControllerDelegate, PGPageBasePlaceholderDelegate, PGSystemNotificationViewDelegate>

@property (nonatomic, strong, readwrite) PGAPIClient *apiClient;
@property (nonatomic, strong, readwrite) FBKVOController *KVOController;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) PGPopupViewController *popupViewController;

@property (nonatomic, strong) PGPageBasePlaceholder *placeholderView;
@property (nonatomic, strong) PGPageBasePlaceholder *lostNetworkPlaceholderView;

@end

@implementation PGBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if ([self respondsToSelector:@selector(initAnalyticsKeys)]) {
        [self initAnalyticsKeys];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestSuccess) name:PG_REQUEST_SUCCESS_NOTIFICATION object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage *backButtonImage = [[UIImage imageNamed:@"pg_navigation_back_button"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(backButtonClicked)];
    // ISSUE: fix left sliding not working, http://blog.csdn.net/meegomeego/article/details/25879605
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    if (PGGlobal.accessToken) {
        [self.apiClient setAuthorizationHeaderField:[NSString stringWithFormat:@"Bearer %@", PGGlobal.accessToken]];
    } else {
        [self.apiClient clearAuthorizationHeader];
    }
    
    PGWeakSelf(self);
    [self observe:PGGlobal keyPath:@"accessToken" block:^(id changedObject) {
        if (PGGlobal.accessToken) {
            [weakself.apiClient setAuthorizationHeaderField:[NSString stringWithFormat:@"Bearer %@", PGGlobal.accessToken]];
        } else {
            [weakself.apiClient clearAuthorizationHeader];
        }
    }];
    [self observe:PGGlobal keyPath:@"hostUrl" block:^(id changedObject) {
        NSString *hostUrl = changedObject;
        if (hostUrl && [hostUrl isKindOfClass:[NSString class]] && hostUrl.length > 0 && ![hostUrl isEqualToString:PGGlobal.hostUrl]) {
            [weakself.apiClient setBaseUrl:hostUrl];
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

- (void)dealloc
{
    [self dismissLoading];
    [self.apiClient cancelAllRequests];
    self.apiClient = nil;
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
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:Theme.fontExtraLargeBold, NSForegroundColorAttributeName:Theme.colorText}];
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

#pragma mark - <UINavigationControllerDelegate>

// NOTE: hide UINavigationBar: http://www.jianshu.com/p/182777e4b034
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:[PGBaseViewController class]]) {
        if ([(PGBaseViewController *)viewController shouldHideNavigationBar]) {
            [self.navigationController setNavigationBarHidden:YES animated:NO];
        } else {
            [self.navigationController setNavigationBarHidden:NO animated:NO];
        }
    } else if ([viewController isKindOfClass:[PGTabBarController class]]) {
        UIViewController *selectedViewController = [(PGTabBarController *)viewController selectedViewController];
        if ([selectedViewController isKindOfClass:[PGBaseViewController class]]) {
            if ([(PGBaseViewController *)selectedViewController shouldHideNavigationBar]) {
                [self.navigationController setNavigationBarHidden:YES animated:NO];
            } else {
                [self.navigationController setNavigationBarHidden:NO animated:NO];
            }
        }
    }
}

- (BOOL)shouldHideNavigationBar
{
    return NO;
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PG_REQUEST_SUCCESS_NOTIFICATION object:nil];
}

- (void)observeCollectionView:(PGBaseCollectionView *)collectionView endOfFeeds:(PGBaseViewModel *)viewModel
{
    __block PGBaseCollectionView *weakCollectionView = collectionView;
    [self observe:viewModel keyPath:@"endFlag" block:^(id changedObject) {
        BOOL endFlag = [changedObject boolValue];
        if (endFlag) {
            [weakCollectionView disableInfiniteScrolling];
            [[weakCollectionView collectionViewLayout] invalidateLayout];
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

- (void)showSystemNotificationPopup
{
    PGSystemNotificationView *notificationView = [[PGSystemNotificationView alloc] initWithFrame:CGRectMake(64, 135, UISCREEN_WIDTH-64*2, 275)];
    notificationView.delegate = self;

    self.popupViewController = [PGPopupViewController popupViewControllerWithPopupView:notificationView];
    [self presentViewController:self.popupViewController animated:YES completion:nil];
}

- (void)dismissPopup
{
    [self.popupViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <PGSystemNotificationViewDelegate>

- (void)dismissSystemNotificationView
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

- (void)showOccupiedLoading
{
    if (!self.hud.superview) {
        self.view.userInteractionEnabled = NO;
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
    self.view.userInteractionEnabled = YES;
    [self.hud hideAnimated:YES];
}

#pragma mark - <Page Placeholder>

- (void)showPlaceholder:(NSString *)image desc:(NSString *)desc
{
    if (self.placeholderView) {
        [self.placeholderView removeFromSuperview];
    }
    [self.placeholderView removeFromSuperview];
    self.placeholderView = [[PGPageBasePlaceholder alloc] initWithImage:image desc:desc top:64.f height:self.view.pg_height-64.f];
    
    [self.view addSubview:self.placeholderView];
}

- (void)showNetworkLostPlaceholder
{
    [self.lostNetworkPlaceholderView removeFromSuperview];
    self.lostNetworkPlaceholderView = [[PGPageBasePlaceholder alloc] initWithImage:@"pg_network_failed_placeholder"
                                                                   desc:@"你的网络已切换至南极线路，点击重试"
                                                            buttonTitle:@"重新加载"
                                                                    top:0.f
                                                                 height:self.view.pg_height];
    self.lostNetworkPlaceholderView.delegate = self;
    
    [self.view addSubview:self.lostNetworkPlaceholderView];
    
}

- (void)hideNetworkLostPlaceholder
{
    if (self.lostNetworkPlaceholderView) {
        self.lostNetworkPlaceholderView.delegate = nil;
        [self.lostNetworkPlaceholderView removeFromSuperview];
    }
}

#pragma mark - <PGPageBasePlaceholderDelegate>

- (void)reloadButtonClicked
{
    if ([(id<PGViewController>)self respondsToSelector:@selector(reloadView)]) {
        [(id<PGViewController>)self reloadView];
    } else {
        [self hideNetworkLostPlaceholder];
    }
}

#pragma mark - <Success Handling>

- (void)requestSuccess
{
    [self hideNetworkLostPlaceholder];
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
        [self hideNetworkLostPlaceholder];
    } else if (errorCode == -1009) {
        [self showNetworkLostPlaceholder];
    } else {
        [self hideNetworkLostPlaceholder];
    }
}

#pragma mark - <Setters && Getters>

- (PGAPIClient *)apiClient
{
    if (!_apiClient) {
        _apiClient = [PGAPIClient clientWithBaseUrl:PGGlobal.hostUrl];
        if (PGGlobal.accessToken) {
            [_apiClient setAuthorizationHeaderField:[NSString stringWithFormat:@"Bearer %@", PGGlobal.accessToken]];
        } else {
            [_apiClient clearAuthorizationHeader];
        }
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
