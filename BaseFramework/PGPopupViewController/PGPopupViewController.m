//
//  PGPopupViewController.m
//  Penguin
//
//  Created by Jing Dai on 8/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGPopupViewController.h"

@interface PGPopupViewController ()

@end

@implementation PGPopupViewController

+ (PGPopupViewController *)popupViewControllerWithPopupView:(UIView *)popupView
{
    PGPopupViewController *popupViewController = [[PGPopupViewController alloc] init];
    
    [popupViewController.view addSubview:popupView];
    
    return popupViewController;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.view.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.8f];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
