//
//  PGTabBarController.m
//  Penguin
//
//  Created by Jing Dai on 6/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

static const float TabBarHeight = 50.f;

#import "PGTabBarController.h"
#import "PGTabBar.h"
#import "PGTab.h"

@interface PGTabBarController () <PGTabBarDelegate>

@property (nonatomic, strong, readwrite) NSArray *viewControllers;

@property (nonatomic, strong, readwrite) UIViewController *selectedViewController;
@property (nonatomic) NSInteger selectedIndex;

@property (nonatomic, strong) PGTabBar *tabBar;

@end

@implementation PGTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    if (viewControllers.count == 0) {
        return;
    }
    _viewControllers = viewControllers;
    
    if ([self respondsToSelector:@selector(addChildViewController:)]) {
        for (UIViewController *vc in viewControllers) {
            [self addChildViewController:vc];
        }
    }
    
    [self setSelectedViewController:viewControllers[0]];
}

- (void)selectTab:(NSInteger)index
{
    
}

- (void)setSelectedViewController:(UIViewController *)viewController
{
    if (![self.selectedViewController isEqual:viewController]) {
        // remove child view controllers
        [self.selectedViewController.view removeFromSuperview];
        [self.selectedViewController removeFromParentViewController];
        [self.selectedViewController didMoveToParentViewController:nil];
        
        viewController.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-TabBarHeight);
        
        // add child view controller
        [self.view addSubview:viewController.view];
        [self addChildViewController:viewController];
        [viewController didMoveToParentViewController:self];
        
        _selectedIndex = [self.viewControllers indexOfObject:viewController];
        _selectedViewController = viewController;
    }
    
    [self loadTabs];
}

- (void)loadTabs
{
    NSMutableArray *tabs = [NSMutableArray new];
    
    for (id<PGTabBarControllerDelegate> vc in _viewControllers) {
        NSString *tabBarTitle = [vc tabBarTitle];
        NSString *tabBarImage = [vc tabBarImage];
        NSString *tabBarHighlightImage = [vc tabBarHighlightImage];
        
        PGTab *tab = [[PGTab alloc] init];
        [tab setBackgroundColor:[UIColor clearColor]];
        tab.tabTitle = tabBarTitle;
        tab.tabImage = tabBarImage;
        tab.tabHighlightImage = tabBarHighlightImage;
        
        [tabs addObject:tab];
    }
    
    [self.tabBar setTabs:[NSArray arrayWithArray:tabs]];
    [self.view addSubview:self.tabBar];
}

#pragma mark - <PGTabBarDelegate>

- (void)tabBarDidSelect:(NSInteger)index
{
    if (index < self.viewControllers.count) {
        UIViewController *selectedVC = self.viewControllers[index];
        [self setSelectedViewController:selectedVC];
        
        if ([selectedVC respondsToSelector:@selector(tabBarDidClicked)]) {
            id<PGTabBarControllerDelegate> vc = selectedVC;
            [vc tabBarDidClicked];
        }
    }
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    // http://www.th7.cn/Program/IOS/201606/881633.shtml
    return _selectedViewController;
}

#pragma mark - <Setters && Getters>

- (PGTabBar *)tabBar
{
    if (!_tabBar) {
        _tabBar = [[PGTabBar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-TabBarHeight, CGRectGetWidth(self.view.frame), TabBarHeight)];
        _tabBar.delegate = self;
    }
    
    return _tabBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
