//
//  PGExploreViewController.m
//  Penguin
//
//  Created by Jing Dai on 7/8/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define ExploreHeaderView @"ExploreHeaderView"

#import "PGExploreViewController.h"
#import "PGScenarioViewController.h"
#import "PGArticleViewController.h"

#import "PGFeedsCollectionView.h"
#import "PGExploreRecommendsHeaderView.h"

#import "PGExploreViewModel.h"

#import "MSWeakTimer.h"

@interface PGExploreViewController () <PGFeedsCollectionViewDelegate>

@property (nonatomic, strong) PGFeedsCollectionView *feedsCollectionView;
@property (nonatomic, strong) PGNavigationView *naviView;

@property (nonatomic, strong) PGExploreViewModel *viewModel;

@property (nonatomic, strong) MSWeakTimer *weakTimer;

@end

@implementation PGExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.naviView];
    [self.view addSubview:self.feedsCollectionView];
    
    self.viewModel = [[PGExploreViewModel alloc] initWithAPIClient:self.apiClient];
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"feedsArray" block:^(id changedObject) {
        NSArray *bannersArray = changedObject;
        if (bannersArray && [bannersArray isKindOfClass:[NSArray class]]) {
            [weakself.feedsCollectionView reloadData];
        }
        [weakself dismissLoading];
        [weakself.feedsCollectionView endBottomRefreshing];
    }];
    [self observe:self.viewModel keyPath:@"error" block:^(id changedObject) {
        NSError *error = changedObject;
        if (error && [error isKindOfClass:[NSError class]]) {
            [weakself showErrorMessage:error];
            [weakself dismissLoading];
            [weakself.feedsCollectionView endTopRefreshing];
            [weakself.feedsCollectionView endBottomRefreshing];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.weakTimer = [MSWeakTimer scheduledTimerWithTimeInterval:1.0
                                                          target:self
                                                        selector:@selector(countdown)
                                                        userInfo:nil
                                                         repeats:YES
                                                   dispatchQueue:dispatch_get_main_queue()];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // NOTE: put it in viewWillAppear doesn't work
    [self setNeedsStatusBarAppearanceUpdate];
    
    if (self.viewModel.feedsArray.count == 0) {
        [self showLoading];
        [self.viewModel requestData];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // http://stackoverflow.com/questions/11656055/scrollviewdidscroll-delegate-is-invoking-automatically
    // NOTE: if barHidden sets to NO, scrollViewDidScroll will not be called (next page nothing to update)
    
    [self.weakTimer invalidate];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)dealloc
{
    [self unobserve];
    [self.weakTimer invalidate];
}

#pragma mark - <PGTabBarControllerDelegate>

- (NSString *)tabBarTitle
{
    return @"发现";
}

- (NSString *)tabBarImage
{
    return @"pg_tab_explore";
}

- (NSString *)tabBarHighlightImage
{
    return @"pg_tab_explore_highlight";
}

- (void)tabBarDidClicked
{
    // NOTE: these codes in viewDidLoad && viewWillLoad will not work since self.navigationController is nil for the first time
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.parentViewController.navigationItem setLeftBarButtonItem:nil];
}

#pragma mark - <PGFeedsCollectionViewDelegate>

- (NSArray *)recommendsArray
{
    return self.viewModel.recommendsArray;
}

- (NSArray *)iconsArray
{
    return self.viewModel.scenariosArray;
}

- (NSArray *)feedsArray
{
    return self.viewModel.feedsArray;
}

- (CGSize)feedsHeaderSize
{
    if (!self.viewModel) {
        return CGSizeZero;
    }
    return [PGExploreRecommendsHeaderView headerViewSize];
}

- (NSString *)tabType
{
    return @"explore";
}

- (void)scenarioDidSelect:(PGCategoryIcon *)scenario
{
    [PGRouterManager routeToScenarioPage:scenario.categoryId link:scenario.link];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id banner = self.viewModel.feedsArray[indexPath.section];
    
    if ([banner isKindOfClass:[PGArticleBanner class]]) {
        PGArticleBanner *articleBanner = (PGArticleBanner *)banner;
        PGArticleViewController *articleVC = [[PGArticleViewController alloc] initWithArticleId:articleBanner.articleId animated:NO];
        [self.navigationController pushViewController:articleVC animated:YES];
    } else if ([banner isKindOfClass:[PGTopicBanner class]]) {
        PGTopicBanner *topicBanner = (PGTopicBanner *)banner;
        [[PGRouter sharedInstance] openURL:topicBanner.link];
    } else if ([banner isKindOfClass:[PGSingleGoodBanner class]]) {
        PGSingleGoodBanner *singleGoodBanner = (PGSingleGoodBanner *)banner;
        [[PGRouter sharedInstance] openURL:singleGoodBanner.link];
    }
}

- (void)countdown
{
    for (UICollectionViewCell *visibleCell in self.feedsCollectionView.visibleCells) {
        if ([visibleCell isKindOfClass:[PGFlashbuyBannerCell class]]) {
            PGFlashbuyBannerCell *cell = (PGFlashbuyBannerCell *)visibleCell;
            NSInteger index = [[self.feedsCollectionView indexPathForCell:cell] section];
            if (index < self.viewModel.feedsArray.count) {
                PGFlashbuyBanner *flashbuy = self.viewModel.feedsArray[index];
                if (flashbuy && [flashbuy isKindOfClass:[PGFlashbuyBanner class]] && cell) {
                    [cell countdown:flashbuy];
                }
            }
        }
    }
}

- (PGFeedsCollectionView *)feedsCollectionView {
    if(_feedsCollectionView == nil) {
        _feedsCollectionView = [[PGFeedsCollectionView alloc] initWithFrame:CGRectMake(0, 64, UISCREEN_WIDTH, UISCREEN_HEIGHT-50-64) collectionViewLayout:[UICollectionViewFlowLayout new]];
        _feedsCollectionView.feedsDelegate = self;
        
        __block PGFeedsCollectionView *collectionView = _feedsCollectionView;
        PGWeakSelf(self);
        [_feedsCollectionView enablePullToRefreshWithTopInset:0.f completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [collectionView endTopRefreshing];
                [weakself.viewModel requestData];
            });
        }];
        [_feedsCollectionView enableInfiniteScrolling:^{
            [weakself.viewModel loadNextPage];
        }];
    }
    return _feedsCollectionView;
}

- (PGNavigationView *)naviView
{
    if (!_naviView) {
        _naviView = [PGNavigationView defaultNavigationView];
    }
    return _naviView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
