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
#import "PGArticleViewController.h"
// view models
#import "PGHomeViewModel.h"
// models
#import "PGCarouselBanner.h"
#import "PGArticleBanner.h"
// views
#import "PGScrollNavigationBar.h"
#import "PGCarouselBannerCell.h"
#import "PGArticleBannerCell.h"
#import "PGHomeArticleHeaderView.h"

@interface PGHomeViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) PGHomeViewModel *viewModel;

@property (nonatomic, strong) UIBarButtonItem *searchButton;
@property (nonatomic, strong) UIBarButtonItem *messageButton;
@property (nonatomic, strong, readwrite) PGBaseCollectionView *feedsCollectionView;

@end

@implementation PGHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageView = @"首页";
    
    self.parentViewController.navigationItem.leftBarButtonItem = self.searchButton;
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

- (void)dealloc
{
    [self unobserve];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationController.scrollNavigationBar.scrollView = self.feedsCollectionView;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.scrollNavigationBar resetToDefaultPositionWithAnimation:NO];
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
        [cell setCellWithImageBanner:banner];
        
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGArticleViewController *articleVC = [[PGArticleViewController alloc] init];
    [self.navigationController pushViewController:articleVC animated:YES];
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
//    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [delegate.window showToast:@"傻逼你出错了！"];
    [PGRouterManager routeToLoginPage];
    
//    PGAlertController *alertController = [PGAlertController alertControllerWithTitle:@"弹窗"
//                                                                             message:@"确认取消吗?"
//                                                                         style:^(PGAlertStyle *style) {
//                                                                             style.alertType = PGAlertTypeActionSheet;
//                                                                         }];
//    PGAlertAction *doneAction = [PGAlertAction actionWithTitle:@"完成"
//                                                         style:nil
//                                                        hander:^{
//                                                            PGLogWarning(@"done button clicked");
//                                                        }];
//    PGAlertAction *deleteAction = [PGAlertAction actionWithTitle:@"删除"
//                                                           style:^(PGAlertActionStyle *style) {
//                                                               style.type = PGAlertActionTypeCancel;
//                                                           } hander:^{
//                                                               PGLogWarning(@"delete button clicked");
//                                                           }];
//    [alertController addActions:@[deleteAction, doneAction]];
//    
//    [self presentViewController:alertController animated:YES completion:nil];
    
//    [self showLoading];
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
        
        [_feedsCollectionView registerClass:[PGCarouselBannerCell class] forCellWithReuseIdentifier:CarouselBannerCell];
        [_feedsCollectionView registerClass:[PGArticleBannerCell class] forCellWithReuseIdentifier:ArticleBannerCell];
        
        [_feedsCollectionView registerClass:[PGHomeArticleHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ArticleHeaderView];
        
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
