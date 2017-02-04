//
//  PGExploreViewController.m
//  Penguin
//
//  Created by Jing Dai on 7/8/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define ExploreHeaderView @"ExploreHeaderView"
#define ArticleHeaderView @"ArticleHeaderView"
#define CategoryCell @"CategoryCell"
#define LevelCell @"LevelCell"
#define GroupCell @"GroupCell"
#define ArticleCell @"ArticleCell"

#import "PGExploreViewController.h"
#import "PGScenarioViewController.h"
#import "PGArticleViewController.h"

#import "PGFeedsCollectionView.h"
#import "PGExploreRecommendsHeaderView.h"
#import "PGScenarioCell.h"
#import "PGArticleBannerCell.h"

#import "PGExploreViewModel.h"

#import "MSWeakTimer.h"

@interface PGExploreViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PGArticleBannerCellDelegate>

@property (nonatomic, strong, readwrite) PGBaseCollectionView *feedsCollectionView;

@property (nonatomic, strong) PGExploreViewModel *viewModel;

@property (nonatomic, assign) BOOL statusbarIsWhiteBackground;

@property (nonatomic, strong) MSWeakTimer *bannersWeakTimer;
@property (nonatomic, strong) PGExploreRecommendsHeaderView *bannersHeaderView;

@end

@implementation PGExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.feedsCollectionView];
    
    self.viewModel = [[PGExploreViewModel alloc] initWithAPIClient:self.apiClient];
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"articlesArray" block:^(id changedObject) {
        NSArray *articlesArray = changedObject;
        if (articlesArray && [articlesArray isKindOfClass:[NSArray class]]) {
            // NOTE: fix reloadData flash http://www.cnblogs.com/Rinpe/p/5850238.html
            [UIView setAnimationsEnabled:NO];
            [weakself.feedsCollectionView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView setAnimationsEnabled:YES];
            });
        }
        [weakself dismissLoading];
        [weakself.feedsCollectionView endTopRefreshing];
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
    [self observeCollectionView:self.feedsCollectionView endOfFeeds:self.viewModel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.bannersWeakTimer = [MSWeakTimer scheduledTimerWithTimeInterval:3.f
                                                                 target:self
                                                               selector:@selector(bannersCountDown)
                                                               userInfo:nil
                                                                repeats:YES
                                                          dispatchQueue:dispatch_get_main_queue()];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // NOTE: put it in viewWillAppear doesn't work
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self reloadView];
    
    if (self.statusbarIsWhiteBackground) {
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            statusBar.backgroundColor = [UIColor whiteColor];
        }
    } else {
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            statusBar.backgroundColor = [UIColor clearColor];
        }
    }
    
    self.feedsCollectionView.contentInset = UIEdgeInsetsZero;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.bannersWeakTimer invalidate];
    
    // http://stackoverflow.com/questions/11656055/scrollviewdidscroll-delegate-is-invoking-automatically
    // NOTE: if barHidden sets to NO, scrollViewDidScroll will not be called (next page nothing to update)
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    // http://www.th7.cn/Program/IOS/201606/881633.shtml fix this method didn't called
    if (self.statusbarIsWhiteBackground) {
        return UIStatusBarStyleDefault;
    } else {
        return UIStatusBarStyleLightContent;
    }
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)dealloc
{
    [self unobserve];
    
    [self.bannersWeakTimer invalidate];
    self.bannersWeakTimer = nil;
}

- (void)reloadView
{
    if (self.viewModel.articlesArray.count == 0) {
        [self showLoading];
        [self.viewModel requestData];
    }
}

- (void)initAnalyticsKeys
{
    self.pageName = explore_tab_view;
}

- (BOOL)shouldHideNavigationBar
{
    return YES;
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

#pragma mark - <UICollectionView>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.viewModel.categoriesArray.count > 0 ? 1 : 0;
    } else if (section == 1) {
        return self.viewModel.levelsArray.count > 0 ? 1 : 0;
    } else if (section == 2) {
        return self.viewModel.groupsArray.count > 0 ? 1 : 0;
    } else if (section == 3) {
        return self.viewModel.articlesArray.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        PGScenarioCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CategoryCell forIndexPath:indexPath];
        
        [cell reloadWithBanners:self.viewModel.categoriesArray title:@"品 类" scenarioType:@"4"];
        
        return cell;
    } else if (indexPath.section == 1) {
        PGScenarioCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LevelCell forIndexPath:indexPath];
        
        [cell reloadWithBanners:self.viewModel.levelsArray title:@"难 易" scenarioType:@"3"];
        
        return cell;
    } else if (indexPath.section == 2) {
        PGScenarioCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GroupCell forIndexPath:indexPath];
        
        [cell reloadWithBanners:self.viewModel.groupsArray title:@"人 群" scenarioType:@"2"];
        
        return cell;
    } else if (indexPath.section == 3) {
        if (self.viewModel.articlesArray.count-indexPath.item == 3) {
            PGWeakSelf(self);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [weakself.viewModel requestArticles];
            });
        }
        
        PGArticleBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleCell forIndexPath:indexPath];
        
        PGArticleBanner *articleBanner = self.viewModel.articlesArray[indexPath.item];
        cell.eventName = article_banner_clicked;
        cell.eventId = articleBanner.articleId;
        cell.pageName = explore_tab_view;
        
        [cell setDelegate:self];
        [cell setCellWithArticle:articleBanner allowGesture:YES];
        
        return cell;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2) {
        return [PGScenarioCell cellSize];
    } else if (indexPath.section == 3) {
        id banner = self.viewModel.articlesArray[indexPath.item];
        if ([banner isKindOfClass:[PGArticleBanner class]]) {
            return [PGArticleBannerCell cellSize];
        } else {
            return CGSizeZero;
        }
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (!self.viewModel) {
        return CGSizeZero;
    }
    if (section == 0) {
        return [PGExploreRecommendsHeaderView headerViewSize];
    }
    if (section == 3) {
        return CGSizeMake(UISCREEN_WIDTH, 60);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        if (!self.viewModel) {
            return CGSizeZero;
        }
        if (self.viewModel.endFlag) {
            return [PGBaseCollectionViewFooterView footerViewSize];
        }
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}
 - (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            self.bannersHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:ExploreHeaderView forIndexPath:indexPath];
            [self.bannersHeaderView reloadBannersWithRecommendsArray:self.viewModel.recommendsArray];
            
            return self.bannersHeaderView;
        } else if (indexPath.section == 3) {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:ArticleHeaderView forIndexPath:indexPath];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 200, 20)];
            label.font = Theme.fontExtraLargeBold;
            label.textColor = Theme.colorText;
            label.text = @"热 门 推 文";
            [headerView addSubview:label];
            
            return headerView;
        }

    } else if (kind == UICollectionElementKindSectionFooter) {
        if (indexPath.section == 3) {
            PGBaseCollectionViewFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BaseCollectionViewFooterView forIndexPath:indexPath];
            
            return footerView;
        }
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        PGArticleBanner *articleBanner = self.viewModel.articlesArray[indexPath.item];
        [PGRouterManager routeToArticlePage:articleBanner.articleId link:articleBanner.link animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // NOTE: add background view to status bar http://stackoverflow.com/questions/19063365/how-to-change-the-status-bar-background-color-and-text-color-on-ios-7
    if (scrollView.contentOffset.y >= UISCREEN_WIDTH*9/16) {
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            statusBar.backgroundColor = [UIColor whiteColor];
        }
        if (!self.statusbarIsWhiteBackground) {
            self.statusbarIsWhiteBackground = YES;
            [self setNeedsStatusBarAppearanceUpdate];
        } else {
            self.statusbarIsWhiteBackground = YES;
        }
    } else {
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            statusBar.backgroundColor = [UIColor clearColor];
        }
        if (self.statusbarIsWhiteBackground) {
            self.statusbarIsWhiteBackground = NO;
            [self setNeedsStatusBarAppearanceUpdate];
        } else {
            self.statusbarIsWhiteBackground = NO;
        }
    }
}

- (void)bannersCountDown
{
    if (self.bannersHeaderView) {
        [self.bannersHeaderView.bannersView scrollToNextPage];
    }
}

#pragma mark - <PGArticleBannerCellDelegate>

- (void)collectArticle:(PGArticleBanner *)article
{
    PGWeakSelf(self);
    __weak PGArticleBanner *weakArticle = article;
    [self.viewModel collectArticle:article.articleId completion:^(BOOL success) {
        if (success) {
            weakArticle.isCollected = YES;
            [weakself showToast:@"收藏成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:PG_NOTIFICATION_UPDATE_ME object:nil];
        }
    }];
}

- (void)disCollectArticle:(PGArticleBanner *)article
{
    PGWeakSelf(self);
    __weak PGArticleBanner *weakArticle = article;
    [self.viewModel disCollectArticle:article.articleId completion:^(BOOL success) {
        if (success) {
            weakArticle.isCollected = NO;
            [weakself showToast:@"取消成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:PG_NOTIFICATION_UPDATE_ME object:nil];
        }
    }];
}

#pragma mark - <Lazy Init>

- (PGBaseCollectionView *)feedsCollectionView {
    if(_feedsCollectionView == nil) {
        _feedsCollectionView = [[PGBaseCollectionView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT-50) collectionViewLayout:[UICollectionViewFlowLayout new]];
        _feedsCollectionView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
        _feedsCollectionView.dataSource = self;
        _feedsCollectionView.delegate = self;
        
        [_feedsCollectionView registerClass:[PGScenarioCell class] forCellWithReuseIdentifier:CategoryCell];
        [_feedsCollectionView registerClass:[PGScenarioCell class] forCellWithReuseIdentifier:LevelCell];
        [_feedsCollectionView registerClass:[PGScenarioCell class] forCellWithReuseIdentifier:GroupCell];
        [_feedsCollectionView registerClass:[PGArticleBannerCell class] forCellWithReuseIdentifier:ArticleCell];
        [_feedsCollectionView registerClass:[PGExploreRecommendsHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ExploreHeaderView];
        [_feedsCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ArticleHeaderView];
        [_feedsCollectionView registerClass:[PGBaseCollectionViewFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:BaseCollectionViewFooterView];
        
        PGWeakSelf(self);
        [_feedsCollectionView enablePullToRefreshWithTopInset:0.f completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself.viewModel clearPagination];
                [weakself.viewModel requestData];
            });
        }];
        [_feedsCollectionView enableInfiniteScrolling:^{
            [weakself.viewModel requestArticles];
        }];
    }
    return _feedsCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
