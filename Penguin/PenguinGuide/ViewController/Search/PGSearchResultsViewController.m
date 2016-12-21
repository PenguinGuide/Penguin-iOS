//
//  PGSearchResultsViewController.m
//  Penguin
//
//  Created by Jing Dai on 8/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGSearchResultsViewController.h"

#import "PGPagedController.h"
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
    
    self.pagedController = [[PGPagedController alloc] init];
    self.pagedController.backgroundColor = [UIColor whiteColor];
    self.pagedController.equalWidth = YES;
    self.pagedController.disableScrolling = YES;
    
    self.pagedController.view.frame = CGRectMake(0, 60, UISCREEN_WIDTH, UISCREEN_HEIGHT-60);
    [self.view addSubview:self.pagedController.view];
    [self addChildViewController:self.pagedController];
    [self.pagedController didMoveToParentViewController:self];
    
    self.articlesVC = [[PGSearchResultsArticlesViewController alloc] initWithKeyword:self.keyword];
    self.goodsVC = [[PGSearchResultsGoodsViewController alloc] initWithKeyword:self.keyword];
    [self.pagedController reloadWithViewControllers:@[self.articlesVC, self.goodsVC] titles:@[@"文 章", @"商 品"] selectedViewClass:[PGCityGuideSegmentIndicator class]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
        self.keyword = trimmedKeyword;
        [self.articlesVC.view removeFromSuperview];
        [self.articlesVC removeFromParentViewController];
        [self.articlesVC didMoveToParentViewController:nil];
        
        [self.goodsVC.view removeFromSuperview];
        [self.goodsVC removeFromParentViewController];
        [self.goodsVC didMoveToParentViewController:nil];
        
        [self.pagedController.view removeFromSuperview];
        [self.pagedController removeFromParentViewController];
        [self.pagedController didMoveToParentViewController:nil];
        
        self.pagedController = [[PGPagedController alloc] init];
        self.pagedController.backgroundColor = [UIColor whiteColor];
        self.pagedController.equalWidth = YES;
        self.pagedController.disableScrolling = YES;
        
        self.pagedController.view.frame = CGRectMake(0, 60, UISCREEN_WIDTH, UISCREEN_HEIGHT-60);
        [self.view addSubview:self.pagedController.view];
        [self addChildViewController:self.pagedController];
        [self.pagedController didMoveToParentViewController:self];
        
        self.articlesVC = [[PGSearchResultsArticlesViewController alloc] initWithKeyword:self.keyword];
        self.goodsVC = [[PGSearchResultsGoodsViewController alloc] initWithKeyword:self.keyword];
        
        [self.pagedController reloadWithViewControllers:@[self.articlesVC, self.goodsVC] titles:@[@"文 章", @"商 品"] selectedViewClass:[PGCityGuideSegmentIndicator class]];
    }
}

#pragma mark - <Lazy Init>

//- (PGPagedController *)pagedController
//{
//    if (!_pagedController) {
//        _pagedController = [[PGPagedController alloc] init];
//        _pagedController.backgroundColor = [UIColor whiteColor];
//        _pagedController.equalWidth = YES;
//        _pagedController.disableScrolling = YES;
//    }
//    return _pagedController;
//}

//- (PGSearchResultsArticlesViewController *)articlesVC
//{
//    if (!_articlesVC) {
//        _articlesVC = [[PGSearchResultsArticlesViewController alloc] initWithKeyword:self.keyword];
//    }
//    return _articlesVC;
//}
//
//- (PGSearchResultsGoodsViewController *)goodsVC
//{
//    if (!_goodsVC) {
//        _goodsVC = [[PGSearchResultsGoodsViewController alloc] initWithKeyword:self.keyword];
//    }
//    return _goodsVC;
//}

- (PGSearchResultsHeaderView *)headerView {
    if(_headerView == nil) {
        _headerView = [[PGSearchResultsHeaderView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 60)];
        _headerView.delegate = self;
        [_headerView setHeaderViewWithKeyword:self.keyword];
    }
    return _headerView;
}

@end
