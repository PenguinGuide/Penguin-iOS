//
//  PGStoreViewController.m
//  Penguin
//
//  Created by Jing Dai on 7/8/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGStoreViewController.h"
#import "PGSearchRecommendsViewController.h"
#import "PGArticleViewController.h"

#import "PGStoreViewModel.h"

#import "PGFeedsCollectionView.h"
#import "PGStoreRecommendsHeaderView.h"

#import "MSWeakTimer.h"

#import "UIScrollView+PGPullToRefresh.h"

#import "PGSystemNotificationView.h"

@interface PGStoreViewController () <PGFeedsCollectionViewDelegate, PGNavigationViewDelegate>

@property (nonatomic, strong) PGNavigationView *navigationView;

@property (nonatomic, strong) PGStoreViewModel *viewModel;
@property (nonatomic, strong) PGFeedsCollectionView *feedsCollectionView;

@property (nonatomic, strong) MSWeakTimer *flashbuyWeakTimer;
@property (nonatomic, strong) MSWeakTimer *bannersWeakTimer;

@end

@implementation PGStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationView = [PGNavigationView defaultNavigationViewWithSearchButton];
    self.navigationView.delegate = self;
    [self.view addSubview:self.navigationView];
    
    self.viewModel = [[PGStoreViewModel alloc] initWithAPIClient:self.apiClient];
    [self.viewModel requestData];
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"feedsArray" block:^(id changedObject) {
        NSArray *feedsArray = changedObject;
        if (feedsArray && [feedsArray isKindOfClass:[NSArray class]]) {
            if (!weakself.feedsCollectionView.superview) {
                [weakself.view addSubview:weakself.feedsCollectionView];
            }
            [UIView setAnimationsEnabled:NO];
            [weakself.feedsCollectionView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
            if (!weakself.feedsCollectionView.superview) {
                [weakself.view addSubview:weakself.feedsCollectionView];
            }
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
    
    self.flashbuyWeakTimer = [MSWeakTimer scheduledTimerWithTimeInterval:1.f
                                                                  target:self
                                                                selector:@selector(flashbuyCountDown)
                                                                userInfo:nil
                                                                 repeats:YES
                                                           dispatchQueue:dispatch_get_main_queue()];
    self.bannersWeakTimer = [MSWeakTimer scheduledTimerWithTimeInterval:3.f
                                                                 target:self
                                                               selector:@selector(bannersCountDown)
                                                               userInfo:nil
                                                                repeats:YES
                                                          dispatchQueue:dispatch_get_main_queue()];
    
    [self reloadView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.feedsCollectionView.contentInset = UIEdgeInsetsZero;
    
    [self checkSystemNotification];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.flashbuyWeakTimer invalidate];
    [self.bannersWeakTimer invalidate];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)dealloc
{
    [self unobserve];
    
    [self.flashbuyWeakTimer invalidate];
    [self.bannersWeakTimer invalidate];
    self.flashbuyWeakTimer = nil;
    self.bannersWeakTimer = nil;
}

- (void)reloadView
{
    if (self.viewModel.feedsArray.count == 0) {
        [self showLoading];
        [self.viewModel requestData];
    }
}

- (void)initAnalyticsKeys
{
    self.pageName = store_tab_view;
}

- (BOOL)shouldHideNavigationBar
{
    return YES;
}

#pragma mark - <PGTabBarControllerDelegate>

- (NSString *)tabBarTitle
{
    return @"市集";
}

- (NSString *)tabBarImage
{
    return @"pg_tab_store";
}

- (NSString *)tabBarHighlightImage
{
    return @"pg_tab_store_highlight";
}

- (void)tabBarDidClicked
{
    // NOTE: these codes in viewDidLoad && viewWillLoad will not work since self.navigationController is nil for the first time
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.parentViewController.navigationItem.leftBarButtonItem = nil;
    self.parentViewController.navigationItem.titleView = nil;
    
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - <PGFeedsCollectionViewDelegate>

- (NSArray *)recommendsArray
{
    return self.viewModel.recommendsArray;
}

- (NSArray *)iconsArray
{
    return self.viewModel.categoriesArray;
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
    return [PGStoreRecommendsHeaderView headerViewSize];
}

- (CGSize)feedsFooterSize
{
    if (!self.viewModel) {
        return CGSizeZero;
    }
    if (self.viewModel.endFlag) {
        return [PGBaseCollectionViewFooterView footerViewSize];
    }
    return CGSizeZero;
}

- (NSString *)tabType
{
    return @"store";
}

- (void)scenarioDidSelect:(PGScenarioBanner *)scenario
{
    [PGRouterManager routeToScenarioPage:scenario.scenarioId link:scenario.link fromStorePage:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id banner = self.viewModel.feedsArray[indexPath.section];
    if ([banner isKindOfClass:[PGArticleBanner class]]) {
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            statusBar.backgroundColor = [UIColor clearColor];
        }
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

- (void)shouldPreloadNextPage
{
    PGWeakSelf(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [weakself.viewModel requestFeeds];
    });
}

- (void)flashbuyCountDown
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

- (void)bannersCountDown
{
    if (self.feedsCollectionView.storeHeaderView) {
        [self.feedsCollectionView.storeHeaderView.bannersView scrollToNextPage];
    }
}

#pragma mark - <PGNavigationViewDelegate>

- (void)searchButtonClicked
{
    PGSearchRecommendsViewController *searchRecommendsVC = [[PGSearchRecommendsViewController alloc] init];
    PGBaseNavigationController *naviController = [[PGBaseNavigationController alloc] initWithRootViewController:searchRecommendsVC];
    PGGlobal.tempNavigationController = naviController;
    [self presentViewController:naviController animated:NO completion:nil];
}

#pragma mark - <Check System Notification>

- (void)checkSystemNotification
{
    if (![[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
        NSArray *notificationExpireDate = [PGGlobal.cache objectForKey:@"system_notification_expire_date" fromTable:@"General"];
        if (!notificationExpireDate) {
            NSTimeInterval expireTime = [[NSDate date] timeIntervalSince1970]+5*24*60*60;
            [PGGlobal.cache putObject:@[@(expireTime)] forKey:@"system_notification_expire_date" intoTable:@"General"];
            
            PGWeakSelf(self);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself showSystemNotificationPopup];
            });
        } else {
            NSTimeInterval expireTime = [notificationExpireDate.firstObject doubleValue];
            NSDate *expireDate = [NSDate dateWithTimeIntervalSince1970:expireTime];
            if ([[NSDate date] compare:expireDate] == NSOrderedDescending) {
                NSTimeInterval expireTime = [[NSDate date] timeIntervalSince1970]+5*24*60*60;
                [PGGlobal.cache putObject:@[@(expireTime)] forKey:@"system_notification_expire_date" intoTable:@"General"];
                
                PGWeakSelf(self);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakself showSystemNotificationPopup];
                });
            }
        }
    }
}

#pragma mark - <Lazy Init>

- (PGFeedsCollectionView *)feedsCollectionView {
    if(_feedsCollectionView == nil) {
        _feedsCollectionView = [[PGFeedsCollectionView alloc] initWithFrame:CGRectMake(0, 64, UISCREEN_WIDTH, UISCREEN_HEIGHT-50-64) collectionViewLayout:[UICollectionViewFlowLayout new]];
        _feedsCollectionView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
        _feedsCollectionView.feedsDelegate = self;
        
        PGWeakSelf(self);
        [_feedsCollectionView enablePullToRefreshWithTopInset:64-36-5 completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself.viewModel clearPagination];
                [weakself.viewModel requestData];
            });
        }];
        [_feedsCollectionView enableInfiniteScrolling:^{
            [weakself.viewModel requestFeeds];
        }];
    }
    return _feedsCollectionView;
}

- (void)end
{
    PGWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself.feedsCollectionView endPullToRefresh];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
