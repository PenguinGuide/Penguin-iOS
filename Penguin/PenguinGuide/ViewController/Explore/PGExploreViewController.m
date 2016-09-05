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

@interface PGExploreViewController () <PGFeedsCollectionViewDelegate>

@property (nonatomic, strong) PGFeedsCollectionView *feedsCollectionView;

@property (nonatomic, strong) PGExploreViewModel *viewModel;

@end

@implementation PGExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.feedsCollectionView];
    
    self.viewModel = [[PGExploreViewModel alloc] initWithAPIClient:self.apiClient];
    [self.viewModel requestData];
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"bannersArray" block:^(id changedObject) {
        NSArray *bannersArray = changedObject;
        if (bannersArray && [bannersArray isKindOfClass:[NSArray class]]) {
            [weakself.feedsCollectionView reloadData];
        }
    }];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.feedsCollectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)dealloc
{
    [self unobserve];
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
    PGLogWarning(@"explore tabBarDidClicked");
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    self.parentViewController.navigationItem.leftBarButtonItem = nil;
    self.parentViewController.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pg_home_logo"]];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - <PGFeedsCollectionViewDelegate>

- (NSArray *)recommendsArray
{
    return self.viewModel.recommendsArray;
}

- (NSArray *)feedsArray
{
    return self.viewModel.bannersArray;
}

- (CGSize)feedsHeaderSize
{
    return [PGExploreRecommendsHeaderView headerViewSize];
}

- (NSString *)tabType
{
    return @"explore";
}

- (void)scenarioDidSelect:(NSString *)scenarioType
{
    PGScenarioViewController *scenarioVC = [[PGScenarioViewController alloc] init];
    [self.navigationController pushViewController:scenarioVC animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id banner = self.viewModel.bannersArray[indexPath.section];
    
    if ([banner isKindOfClass:[PGArticleBanner class]]) {
        PGArticleBanner *articleBanner = (PGArticleBanner *)banner;
        [[PGRouter sharedInstance] openURL:articleBanner.link];
    } else if ([banner isKindOfClass:[PGTopicBanner class]]) {
        PGTopicBanner *topicBanner = (PGTopicBanner *)banner;
        [[PGRouter sharedInstance] openURL:topicBanner.link];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PGFeedsCollectionView *)feedsCollectionView {
	if(_feedsCollectionView == nil) {
		_feedsCollectionView = [[PGFeedsCollectionView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT-50) collectionViewLayout:[UICollectionViewFlowLayout new]];
        _feedsCollectionView.feedsDelegate = self;
        
        __block PGFeedsCollectionView *collectionView = _feedsCollectionView;
        PGWeakSelf(self);
        [_feedsCollectionView enablePullToRefreshWithTopInset:64.f completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [collectionView endTopRefreshing];
                [weakself.viewModel requestData];
            });
        }];
        [_feedsCollectionView enableInfiniteScrolling:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [collectionView endBottomRefreshing];
            });
        }];
	}
	return _feedsCollectionView;
}

@end
