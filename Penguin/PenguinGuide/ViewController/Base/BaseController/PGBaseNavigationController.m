//
//  PGBaseNavigationController.m
//  Penguin
//
//  Created by Jing Dai on 7/8/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseNavigationController.h"

@interface PGBaseNavigationController ()

@end

@implementation PGBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

// http://www.ithao123.cn/content-680069.html
// http://blog.csdn.net/gxp1032901/article/details/41879557
// http://www.th7.cn/Program/IOS/201606/881633.shtml PGTabBarController.m childViewControllerForStatusBarStyle
// ISSUE: why preferredStatusBarStyle is not called
- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.visibleViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden
{
    return self.visibleViewController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
