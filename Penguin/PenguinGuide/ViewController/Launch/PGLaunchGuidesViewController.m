//
//  PGLaunchGuidesViewController.m
//  Penguin
//
//  Created by Kobe Dai on 16/02/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import "PGLaunchGuidesViewController.h"
#import "FXPageControl.h"
#import "PGLoginViewController.h"
#import "PGSignupViewController.h"

@interface PGLaunchGuidesViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, strong) FXPageControl *imagesPageControl;
@property (nonatomic, strong) UIScrollView *imagesScrollView;

@end

@implementation PGLaunchGuidesViewController

- (id)initWithImages:(NSArray *)imagesArray
{
    if (self = [super init]) {
        self.imagesArray = imagesArray;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoggedIn) name:PG_NOTIFICATION_LOGIN object:nil];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.imagesScrollView];
    [self.view addSubview:self.imagesPageControl];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (BOOL)shouldHideNavigationBar
{
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger prePage = self.imagesPageControl.currentPage;
    
    CGRect visibleBounds = self.imagesScrollView.bounds;
    NSInteger currentPage = (NSInteger)(floorf(CGRectGetMidX(visibleBounds) / CGRectGetWidth(visibleBounds)));
    
    if (currentPage != prePage) {
        [self.imagesPageControl setCurrentPage:currentPage];
    }
}

#pragma mark - <Button Events>

- (void)loginButtonClicked
{
    PGLoginViewController *loginVC = [[PGLoginViewController alloc] init];
    loginVC.isPushedIn = YES;
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void)signupButtonClicked
{
    PGSignupViewController *signupVC = [[PGSignupViewController alloc] init];
    [self.navigationController pushViewController:signupVC animated:YES];
}

- (void)visitsButtonClicked
{
    if (self.completionBlock) {
        self.completionBlock();
    }
}

#pragma mark - <Notification>

- (void)userLoggedIn
{
    if (self.completionBlock) {
        self.completionBlock();
    }
}

#pragma mark - <Lazy Init>

- (FXPageControl *)imagesPageControl
{
    if (!_imagesPageControl) {
        _imagesPageControl = [[FXPageControl alloc] initWithFrame:CGRectMake(0, self.view.pg_height-60, self.view.pg_width, 15)];
        _imagesPageControl.userInteractionEnabled = NO;
        _imagesPageControl.backgroundColor = [UIColor clearColor];
        _imagesPageControl.dotSpacing = 15.f;
        _imagesPageControl.numberOfPages = self.imagesArray.count;
        _imagesPageControl.currentPage = 0;
        
        _imagesPageControl.dotSize = 6.f;
        _imagesPageControl.selectedDotSize = 6.f;
        _imagesPageControl.selectedDotColor = [UIColor colorWithHexString:@"F1F1F1"];
        _imagesPageControl.dotColor = [UIColor colorWithHexString:@"8B8B8B"];
    }
    return _imagesPageControl;
}

- (UIScrollView *)imagesScrollView
{
    if (!_imagesScrollView) {
        _imagesScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.pg_width, self.view.pg_height)];
        _imagesScrollView.backgroundColor = [UIColor whiteColor];
        _imagesScrollView.contentSize = CGSizeMake(self.view.pg_width*self.imagesArray.count, self.view.pg_height);
        _imagesScrollView.delegate = self;
        _imagesScrollView.pagingEnabled = YES;
        _imagesScrollView.showsHorizontalScrollIndicator = NO;
        _imagesScrollView.showsVerticalScrollIndicator = NO;
        
        for (int i = 0; i < self.imagesArray.count; i++) {
            NSString *image = self.imagesArray[i];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*self.view.pg_width, 0, self.view.pg_width, self.view.pg_height)];
            imageView.image = [UIImage imageNamed:image];
            imageView.userInteractionEnabled = YES;
            [_imagesScrollView addSubview:imageView];
            
            if (i == self.imagesArray.count-1) {
                UIButton *visitsButton = [[UIButton alloc] initWithFrame:CGRectMake(60, self.imagesPageControl.pg_top-50, UISCREEN_WIDTH-60*2, 33)];
                [visitsButton setTitle:@"进 入 首 页" forState:UIControlStateNormal];
                [visitsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [visitsButton.titleLabel setFont:Theme.fontLargeBold];
                visitsButton.clipsToBounds = YES;
                visitsButton.layer.borderWidth = 1/[UIScreen mainScreen].scale;
                visitsButton.layer.borderColor = [UIColor whiteColor].CGColor;
                visitsButton.layer.cornerRadius = 4.f;
                [visitsButton addTarget:self action:@selector(visitsButtonClicked) forControlEvents:UIControlEventTouchUpInside];
                [imageView addSubview:visitsButton];
                
                if (!PGGlobal.userId || PGGlobal.userId.length == 0) {
                    CGFloat buttonWidth = (UISCREEN_WIDTH-60*2-20)/2;
                    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(visitsButton.pg_left, visitsButton.pg_top-20-32, buttonWidth, 32)];
                    [loginButton setTitle:@"登 录" forState:UIControlStateNormal];
                    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [loginButton.titleLabel setFont:Theme.fontLargeBold];
                    loginButton.clipsToBounds = YES;
                    loginButton.layer.borderWidth = 1/[UIScreen mainScreen].scale;
                    loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
                    loginButton.layer.cornerRadius = 4.f;
                    [loginButton addTarget:self action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
                    [imageView addSubview:loginButton];
                    
                    UIButton *signupButton = [[UIButton alloc] initWithFrame:CGRectMake(loginButton.pg_right+20, visitsButton.pg_top-20-32, buttonWidth, 32)];
                    [signupButton setTitle:@"注 册" forState:UIControlStateNormal];
                    [signupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [signupButton.titleLabel setFont:Theme.fontLargeBold];
                    signupButton.clipsToBounds = YES;
                    signupButton.layer.borderWidth = 1/[UIScreen mainScreen].scale;
                    signupButton.layer.borderColor = [UIColor whiteColor].CGColor;
                    signupButton.layer.cornerRadius = 4.f;
                    [signupButton addTarget:self action:@selector(signupButtonClicked) forControlEvents:UIControlEventTouchUpInside];
                    [imageView addSubview:signupButton];
                }
            } else {
                
            }
        }
    }
    return _imagesScrollView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
