//
//  PGSearchResultsViewController.m
//  Penguin
//
//  Created by Jing Dai on 8/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGSearchResultsViewController.h"

#import "UIViewController+PGPagedController.h"
#import "PGSearchResultsArticlesViewController.h"
#import "PGSearchResultsGoodsViewController.h"

#import "PGCityGuideSegmentIndicator.h"
#import "PGSearchResultsHeaderView.h"

@interface PGSearchResultsViewController () <PGSearchResultsHeaderViewDelegate>

@property (nonatomic, strong) NSString *keyword;

@property (nonatomic, strong) PGPagedController *pagedController;
@property (nonatomic, strong) PGSearchResultsArticlesViewController *articlesVC;
@property (nonatomic, strong) PGSearchResultsGoodsViewController *goodsVC;

@property (nonatomic, strong) PGSearchResultsHeaderView *headerView;

@end

@implementation PGSearchResultsViewController

- (id)initWithKeyword:(NSString *)keyword
{
    if (self = [super init]) {
        self.keyword = keyword;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.headerView];
    
    self.articlesVC = [[PGSearchResultsArticlesViewController alloc] initWithKeyword:self.keyword];
    self.goodsVC = [[PGSearchResultsGoodsViewController alloc] initWithKeyword:self.keyword];
    
    [self addPagedController:CGRectMake(0, 60, UISCREEN_WIDTH, UISCREEN_HEIGHT-60)
             viewControllers:@[self.articlesVC, self.goodsVC]
               segmentConfig:^(PGSegmentedControlConfig *config) {
                   config.titles = @[@"文 章", @"商 品"];
                   config.SelectedViewClass = [PGCityGuideSegmentIndicator class];
                   config.equalWidth = YES;
                   config.backgroundColor = [UIColor whiteColor];
               }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (BOOL)shouldHideNavigationBar
{
    return YES;
}

- (void)initAnalyticsKeys
{
    self.pageName = search_results_view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <PGSearchResultsHeaderViewDelegate>

- (void)cancelButtonClicked
{
    PGGlobal.tempNavigationController = nil;
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchButtonClicked:(NSString *)keyword
{
    NSString *trimmedKeyword = [[keyword componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
    
    if (![trimmedKeyword isEqualToString:self.keyword] && ![trimmedKeyword isEqualToString:@""]) {
        self.keyword = keyword;
        [self.articlesVC.view removeFromSuperview];
        [self.articlesVC removeFromParentViewController];
        [self.articlesVC didMoveToParentViewController:nil];
        
        [self.goodsVC.view removeFromSuperview];
        [self.goodsVC removeFromParentViewController];
        [self.goodsVC didMoveToParentViewController:nil];
        
        self.articlesVC = [[PGSearchResultsArticlesViewController alloc] initWithKeyword:self.keyword];
        self.goodsVC = [[PGSearchResultsGoodsViewController alloc] initWithKeyword:self.keyword];
        
        [self addPagedController:CGRectMake(0, 60, UISCREEN_WIDTH, UISCREEN_HEIGHT-60)
                 viewControllers:@[self.articlesVC, self.goodsVC]
                   segmentConfig:^(PGSegmentedControlConfig *config) {
                       config.titles = @[@"文 章", @"商 品"];
                       config.SelectedViewClass = [PGCityGuideSegmentIndicator class];
                       config.equalWidth = YES;
                       config.backgroundColor = [UIColor whiteColor];
                   }];
    }
}

#pragma mark - <Lazy Init>

- (PGSearchResultsHeaderView *)headerView {
    if(_headerView == nil) {
        _headerView = [[PGSearchResultsHeaderView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 60)];
        _headerView.delegate = self;
        [_headerView setHeaderViewWithKeyword:self.keyword];
    }
    return _headerView;
}

@end
