//
//  PGHomeViewController.m
//  Penguin
//
//  Created by Jing Dai on 7/8/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define CarouselBannerCell @"CarouselBannerCell"
#define ArticleBannerCell @"ArticleBannerCell"

#define ArticleHeaderView @"ArticleHeaderView"

// view controllers
#import "PGHomeViewController.h"
#import "PGLoginViewController.h"
// view models
#import "PGHomeViewModel.h"
// models
#import "PGCarouselBanner.h"
#import "PGArticleBanner.h"
// views
#import "PGCarouselBannerCell.h"
#import "PGArticleBannerCell.h"
#import "PGHomeArticleHeaderView.h"

#import "ViewController.h"

@interface PGHomeViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) PGHomeViewModel *viewModel;

@property (nonatomic, strong) UIBarButtonItem *searchButton;
@property (nonatomic, strong) UIBarButtonItem *messageButton;
@property (nonatomic, strong) PGBaseCollectionView *feedsCollectionView;

@end

@implementation PGHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.parentViewController.navigationItem.leftBarButtonItem = self.searchButton;
    self.parentViewController.navigationItem.rightBarButtonItem = self.messageButton;
    self.parentViewController.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pg_home_logo"]];
    
    [self.view addSubview:self.feedsCollectionView];
    
    self.viewModel = [[PGHomeViewModel alloc] initWithAPIClient:self.apiClient];
    [self.viewModel requestData];
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"dataArray" block:^(id changedObject) {
        NSArray *bannersArray = changedObject;
        if (bannersArray && [bannersArray isKindOfClass:[NSArray class]]) {
            [weakself.feedsCollectionView reloadData];
        }
    }];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.viewModel.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id banner = self.viewModel.dataArray[section];
    if ([banner isKindOfClass:[PGCarouselBanner class]]) {
        return 1;
    } else if ([banner isKindOfClass:[PGArticleBanner class]]) {
        PGArticleBanner *articleBanner = (PGArticleBanner *)banner;
        return articleBanner.banners.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id banner = self.viewModel.dataArray[indexPath.section];
    if ([banner isKindOfClass:[PGCarouselBanner class]]) {
        PGCarouselBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CarouselBannerCell forIndexPath:indexPath];
        
        PGCarouselBanner *carouselBanner = (PGCarouselBanner *)banner;
        [cell reloadBannersWithData:carouselBanner.banners];
        
        return cell;
    } else if ([banner isKindOfClass:[PGArticleBanner class]]) {
        PGArticleBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleBannerCell forIndexPath:indexPath];
        
        PGArticleBanner *articleBanner = (PGArticleBanner *)banner;
        PGImageBanner *banner = articleBanner.banners[indexPath.item];
        [cell setCellWithImage:banner.image];
        
        return cell;
    }
    
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    id banner = self.viewModel.dataArray[indexPath.section];
    if ([banner isKindOfClass:[PGArticleBanner class]]) {
        PGHomeArticleHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ArticleHeaderView forIndexPath:indexPath];
        
        PGArticleBanner *articleBanner = (PGArticleBanner *)banner;
        headerView.dateLabel.text = articleBanner.desc;
        
        return headerView;
    }
    return nil;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id banner = self.viewModel.dataArray[indexPath.section];
    if ([banner isKindOfClass:[PGCarouselBanner class]]) {
        return [PGCarouselBannerCell cellSize];
    } else if ([banner isKindOfClass:[PGArticleBanner class]]) {
        return [PGArticleBannerCell cellSize];
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    id banner = self.viewModel.dataArray[section];
    if ([banner isKindOfClass:[PGArticleBanner class]]) {
        return CGSizeMake(UISCREEN_WIDTH, 35);
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
    return UIEdgeInsetsZero;
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

#pragma mark - <Button Events>

- (void)searchButtonClicked
{
    ViewController *vc = [[ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)messageButtonClicked
{
    [PGRouterManager routeToLoginPage];
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

- (UIBarButtonItem *)messageButton
{
    if (!_messageButton) {
        _messageButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pg_home_message_button"]
                                                          style:UIBarButtonItemStyleDone
                                                         target:self
                                                         action:@selector(messageButtonClicked)];
    }
    return _messageButton;
}

- (PGBaseCollectionView *)feedsCollectionView
{
    if (!_feedsCollectionView) {
        _feedsCollectionView = [[PGBaseCollectionView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT-50) collectionViewLayout:[UICollectionViewFlowLayout new]];
        _feedsCollectionView.dataSource = self;
        _feedsCollectionView.delegate = self;
        _feedsCollectionView.showsHorizontalScrollIndicator = NO;
        _feedsCollectionView.showsVerticalScrollIndicator = NO;
        
        [_feedsCollectionView registerClass:[PGCarouselBannerCell class] forCellWithReuseIdentifier:CarouselBannerCell];
        [_feedsCollectionView registerClass:[PGArticleBannerCell class] forCellWithReuseIdentifier:ArticleBannerCell];
        
        [_feedsCollectionView registerClass:[PGHomeArticleHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ArticleHeaderView];
        
        __block PGBaseCollectionView *collectionView = _feedsCollectionView;
        [_feedsCollectionView enablePullToRefresh:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [collectionView endTopRefreshing];
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
