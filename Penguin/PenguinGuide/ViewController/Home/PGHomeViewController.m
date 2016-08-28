//
//  PGHomeViewController.m
//  Penguin
//
//  Created by Jing Dai on 7/8/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define CarouselBannerCell @"CarouselBannerCell"
#define ArticleBannerCell @"ArticleBannerCell"
#define GoodsCollectionBannerCell @"GoodsCollectionBannerCell"
#define TopicBannerCell @"TopicBannerCell"
#define SingleGoodBannerCell @"SingleGoodBannerCell"
#define FlashbuyBannerCell @"FlashbuyBannerCell"

#define HomeHeaderView @"HomeHeaderView"

#import "UINavigationBar+PGTransparentNaviBar.h"
#import "MSWeakTimer.h"

// view controllers
#import "PGHomeViewController.h"
#import "PGLoginViewController.h"
#import "PGArticleViewController.h"
#import "PGChannelViewController.h"
#import "PGSearchRecommendsViewController.h"
// view models
#import "PGHomeViewModel.h"
// models
#import "PGCarouselBanner.h"
#import "PGArticleBanner.h"
#import "PGFlashbuyBanner.h"
#import "PGGoodsCollectionBanner.h"
#import "PGTopicBanner.h"
#import "PGSingleGoodBanner.h"
// views
#import "PGHomeRecommendsHeaderView.h"
// cells
#import "PGCarouselBannerCell.h"
#import "PGArticleBannerCell.h"
#import "PGGoodsCollectionBannerCell.h"
#import "PGTopicBannerCell.h"
#import "PGSingleGoodBannerCell.h"
#import "PGFlashbuyBannerCell.h"

@interface PGHomeViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PGHomeRecommendsHeaderViewDelegate>

@property (nonatomic, strong) PGHomeViewModel *viewModel;
@property (nonatomic, strong, readwrite) PGBaseCollectionView *feedsCollectionView;

@property (nonatomic, strong) UIBarButtonItem *searchButton;
@property (nonatomic, strong) UIBarButtonItem *messageButton;

@property (nonatomic, strong) MSWeakTimer *weakTimer;

@end

@implementation PGHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageView = @"首页";
    
    self.parentViewController.navigationItem.leftBarButtonItem = self.searchButton;
    self.parentViewController.navigationItem.titleView = nil;
    
    [self.view addSubview:self.feedsCollectionView];
    
    self.viewModel = [[PGHomeViewModel alloc] initWithAPIClient:self.apiClient];
    [self.viewModel requestData];
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"feedsArray" block:^(id changedObject) {
        NSArray *bannersArray = changedObject;
        if (bannersArray && [bannersArray isKindOfClass:[NSArray class]]) {
            [weakself.feedsCollectionView reloadData];
        }
    }];
}

- (void)dealloc
{
    [self unobserve];
    [self.weakTimer invalidate];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // http://blog.csdn.net/ws1352864983/article/details/51932388
    
    // these codes in viewDidLoad will not work
    [self.navigationController.navigationBar pg_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.weakTimer = [MSWeakTimer scheduledTimerWithTimeInterval:1.0
                                                          target:self
                                                        selector:@selector(countdown)
                                                        userInfo:nil
                                                         repeats:YES
                                                   dispatchQueue:dispatch_get_main_queue()];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar pg_reset];
    
    [self.weakTimer invalidate];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    // http://www.th7.cn/Program/IOS/201606/881633.shtml fix this method didn't called
    return UIStatusBarStyleLightContent;
}

#pragma mark - <PGTabBarControllerDelegate>

- (NSString *)tabBarTitle
{
    return @"首页";
}

- (NSString *)tabBarImage
{
    return @"pg_tab_home";
}

- (NSString *)tabBarHighlightImage
{
    return @"pg_tab_home_highlight";
}

- (void)tabBarDidClicked
{
    PGLogWarning(@"home tabBarDidClicked");
    
    [self.navigationController.navigationBar pg_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.parentViewController.navigationItem.leftBarButtonItem = self.searchButton;
    self.parentViewController.navigationItem.titleView = nil;
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.viewModel.feedsArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id banner = self.viewModel.feedsArray[section];
    if ([banner isKindOfClass:[PGCarouselBanner class]]) {
        return 1;
    } else if ([banner isKindOfClass:[PGArticleBanner class]]) {
        return 1;
    } else if ([banner isKindOfClass:[PGGoodsCollectionBanner class]]) {
        return 1;
    } else if ([banner isKindOfClass:[PGTopicBanner class]]) {
        return 1;
    } else if ([banner isKindOfClass:[PGSingleGoodBanner class]]) {
        return 1;
    } else if ([banner isKindOfClass:[PGFlashbuyBanner class]]) {
        return 1;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id banner = self.viewModel.feedsArray[indexPath.section];
    if ([banner isKindOfClass:[PGCarouselBanner class]]) {
        PGCarouselBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CarouselBannerCell forIndexPath:indexPath];
        
        PGCarouselBanner *carouselBanner = (PGCarouselBanner *)banner;
        [cell reloadBannersWithData:carouselBanner.banners];
        
        return cell;
    } else if ([banner isKindOfClass:[PGArticleBanner class]]) {
        PGArticleBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleBannerCell forIndexPath:indexPath];
        
        PGArticleBanner *articleBanner = (PGArticleBanner *)banner;
        [cell setCellWithArticle:articleBanner];
        
        return cell;
    } else if ([banner isKindOfClass:[PGGoodsCollectionBanner class]]) {
        PGGoodsCollectionBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodsCollectionBannerCell forIndexPath:indexPath];
        
        PGGoodsCollectionBanner *goodsCollectionBanner = (PGGoodsCollectionBanner *)banner;
        [cell setCellWithGoodsCollection:goodsCollectionBanner];
        
        return cell;
    } else if ([banner isKindOfClass:[PGTopicBanner class]]) {
        PGTopicBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TopicBannerCell forIndexPath:indexPath];
        
        PGTopicBanner *topicBanner = (PGTopicBanner *)banner;
        [cell setCellWithTopic:topicBanner];
        
        return cell;
    } else if ([banner isKindOfClass:[PGSingleGoodBanner class]]) {
        PGSingleGoodBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SingleGoodBannerCell forIndexPath:indexPath];
        
        PGSingleGoodBanner *singleGoodBanner = (PGSingleGoodBanner *)banner;
        [cell setCellWithSingleGood:singleGoodBanner];
        
        return cell;
    } else if ([banner isKindOfClass:[PGFlashbuyBanner class]]) {
        PGFlashbuyBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FlashbuyBannerCell forIndexPath:indexPath];
        
        PGFlashbuyBanner *flashbuyBanner = (PGFlashbuyBanner *)banner;
        [cell reloadBannersWithFlashbuy:flashbuyBanner];
        [cell countdown:flashbuyBanner];
        
        return cell;
    }
    
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        PGHomeRecommendsHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomeHeaderView forIndexPath:indexPath];
        headerView.delegate = self;
        [headerView reloadBannersWithData:self.viewModel.recommendsArray];
        
        return headerView;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id banner = self.viewModel.feedsArray[indexPath.section];
    if ([banner isKindOfClass:[PGArticleBanner class]]) {
        PGArticleViewController *articleVC = [[PGArticleViewController alloc] init];
        [self.navigationController pushViewController:articleVC animated:YES];
    }
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id banner = self.viewModel.feedsArray[indexPath.section];
    if ([banner isKindOfClass:[PGCarouselBanner class]]) {
        return [PGCarouselBannerCell cellSize];
    } else if ([banner isKindOfClass:[PGArticleBanner class]]) {
        return [PGArticleBannerCell cellSize];
    } else if ([banner isKindOfClass:[PGGoodsCollectionBanner class]]) {
        return [PGGoodsCollectionBannerCell cellSize];
    } else if ([banner isKindOfClass:[PGTopicBanner class]]) {
        return [PGTopicBannerCell cellSize];
    } else if ([banner isKindOfClass:[PGSingleGoodBanner class]]) {
        return [PGSingleGoodBannerCell cellSize];
    } else if ([banner isKindOfClass:[PGFlashbuyBanner class]]) {
        return [PGFlashbuyBannerCell cellSize];
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.viewModel.recommendsArray) {
            return [PGHomeRecommendsHeaderView headerViewSize];
        }
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 12, 0);
}

#pragma mark - <Button Events>

- (void)searchButtonClicked
{
    PGSearchRecommendsViewController *searchRecommendsVC = [[PGSearchRecommendsViewController alloc] init];
    [self presentViewController:searchRecommendsVC animated:NO completion:nil];
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

#pragma mark - <PGHomeRecommendsHeaderViewDelegate>

- (void)channelDidSelect:(NSString *)tagId
{
    PGChannelViewController *channelVC = [[PGChannelViewController alloc] init];
    [self.navigationController pushViewController:channelVC animated:YES];
}

#pragma mark - <Setters && Getters>

- (UIBarButtonItem *)searchButton
{
    if (!_searchButton) {
        _searchButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pg_home_search_button"]
                                                         style:UIBarButtonItemStyleDone
                                                        target:self
                                                        action:@selector(searchButtonClicked)];
    }
    return _searchButton;
}

- (PGBaseCollectionView *)feedsCollectionView
{
    if (!_feedsCollectionView) {
        _feedsCollectionView = [[PGBaseCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[UICollectionViewFlowLayout new]];
        _feedsCollectionView.dataSource = self;
        _feedsCollectionView.delegate = self;
        _feedsCollectionView.showsHorizontalScrollIndicator = NO;
        _feedsCollectionView.showsVerticalScrollIndicator = NO;
        _feedsCollectionView.backgroundColor = Theme.colorBackground;
        
        [_feedsCollectionView registerClass:[PGCarouselBannerCell class] forCellWithReuseIdentifier:CarouselBannerCell];
        [_feedsCollectionView registerClass:[PGArticleBannerCell class] forCellWithReuseIdentifier:ArticleBannerCell];
        [_feedsCollectionView registerClass:[PGGoodsCollectionBannerCell class] forCellWithReuseIdentifier:GoodsCollectionBannerCell];
        [_feedsCollectionView registerClass:[PGTopicBannerCell class] forCellWithReuseIdentifier:TopicBannerCell];
        [_feedsCollectionView registerClass:[PGSingleGoodBannerCell class] forCellWithReuseIdentifier:SingleGoodBannerCell];
        [_feedsCollectionView registerClass:[PGFlashbuyBannerCell class] forCellWithReuseIdentifier:FlashbuyBannerCell];
        
        [_feedsCollectionView registerClass:[PGHomeRecommendsHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomeHeaderView];
        
        __block PGBaseCollectionView *collectionView = _feedsCollectionView;
        PGWeakSelf(self);
        [_feedsCollectionView enablePullToRefresh:^{
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
