//
//  PGCityGuideViewController.m
//  Penguin
//
//  Created by Jing Dai on 24/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGCityGuideViewController.h"
#import "PGCityGuideArticlesViewController.h"
#import "PGCityGuideSegmentIndicator.h"

#import "PGCityGuideViewModel.h"

@interface PGCityGuideViewController ()

@property (nonatomic, strong, readwrite) PGPagedController *pagedController;
@property (nonatomic, strong) PGCityGuideViewModel *viewModel;

@end

@implementation PGCityGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.parentViewController.navigationItem.leftBarButtonItem = nil;
    self.parentViewController.navigationItem.titleView = nil;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.viewModel = [[PGCityGuideViewModel alloc] initWithAPIClient:self.apiClient];
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"citiesArray" block:^(id changedObject) {
        NSArray *citiesArray = changedObject;
        if (citiesArray && [citiesArray isKindOfClass:[NSArray class]]) {
            [weakself reloadAllCities];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self reloadView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)dealloc
{
    [self unobserve];
}

- (void)reloadView
{
    if (self.viewModel.citiesArray.count == 0) {
        [self.viewModel requestData];
    }
}

- (void)initAnalyticsKeys
{
    self.pageName = city_guide_tab_view;
}

- (BOOL)shouldHideNavigationBar
{
    return YES;
}

#pragma mark - <PGTabBarControllerDelegate>

- (NSString *)tabBarTitle
{
    return @"城市指南";
}

- (NSString *)tabBarImage
{
    return @"pg_tab_city_guide";
}

- (NSString *)tabBarHighlightImage
{
    return @"pg_tab_city_guide_highlight";
}

- (void)tabBarDidClicked
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.parentViewController.navigationItem.leftBarButtonItem = nil;
    self.parentViewController.navigationItem.titleView = nil;
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)reloadAllCities
{
    NSMutableArray *cityViewControllers = [NSMutableArray new];
    NSMutableArray *cityNames = [NSMutableArray new];
    PGCityGuideArticlesViewController *allCitiesVC = [[PGCityGuideArticlesViewController alloc] initWithCityId:@"all"];
    [cityViewControllers addObject:allCitiesVC];
    [cityNames addObject:@"全部"];
    
    for (PGCityGuideCity *city in self.viewModel.citiesArray) {
        if (city.cityName.length > 0 && city.cityId.length > 0) {
            PGCityGuideArticlesViewController *vc = [[PGCityGuideArticlesViewController alloc] initWithCityId:city.cityId];
            [cityViewControllers addObject:vc];
            [cityNames addObject:city.cityName];
        }
    }
    
    self.pagedController.viewControllers = [NSArray arrayWithArray:cityViewControllers];
    self.pagedController.titles = [NSArray arrayWithArray:cityNames];
    self.pagedController.SelectedViewClass = [PGCityGuideSegmentIndicator class];
    
    if (![self.childViewControllers containsObject:self.pagedController]) {
        [self.view addSubview:self.pagedController.view];
        [self addChildViewController:self.pagedController];
        [self.pagedController didMoveToParentViewController:self];
    } else {
        [self.pagedController reload];
    }
}

#pragma mark - <Lazy Init>

- (PGPagedController *)pagedController
{
    if (!_pagedController) {
        _pagedController = [[PGPagedController alloc] init];
        _pagedController.view.frame = CGRectMake(0, 20, self.view.pg_width, self.view.pg_height-20);
        _pagedController.segmentHeight = 60.f;
        _pagedController.SelectedViewClass = [PGCityGuideSegmentIndicator class];
    }
    return _pagedController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
