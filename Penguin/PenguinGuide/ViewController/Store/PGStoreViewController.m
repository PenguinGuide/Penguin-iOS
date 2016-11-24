//
//  PGStoreViewController.m
//  Penguin
//
//  Created by Jing Dai on 7/8/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGStoreViewController.h"
#import "PGStoreCategoryViewController.h"

#import "PGStoreViewModel.h"

#import "PGFeedsCollectionView.h"
#import "PGStoreRecommendsHeaderView.h"

#import "MSWeakTimer.h"

@interface PGStoreViewController () <PGFeedsCollectionViewDelegate>

@property (nonatomic, strong) PGStoreViewModel *viewModel;
@property (nonatomic, strong) PGFeedsCollectionView *feedsCollectionView;
//@property (nonatomic, strong) PGNavigationView *naviView;

@property (nonatomic, strong) MSWeakTimer *weakTimer;

@property (nonatomic, assign) BOOL statusbarIsWhiteBackground;

@end

@implementation PGStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self.view addSubview:self.naviView];
    [self.view addSubview:self.feedsCollectionView];
    
    self.viewModel = [[PGStoreViewModel alloc] initWithAPIClient:self.apiClient];
    [self.viewModel requestData];
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"reloadFirstPage" block:^(id changedObject) {
        BOOL reloadFirstPage = [changedObject boolValue];
        if (reloadFirstPage)  {
            [weakself.feedsCollectionView reloadData];
            [weakself dismissLoading];
            [weakself.feedsCollectionView endBottomRefreshing];
        }
    }];
    [self observe:self.viewModel keyPath:@"nextPageIndexSet" block:^(id changedObject) {
        NSIndexSet *indexes = changedObject;
        if (indexes && [indexes isKindOfClass:[NSIndexSet class]] && indexes.count > 0) {
            @try {
                [weakself.feedsCollectionView performBatchUpdates:^{
                    [weakself.feedsCollectionView insertSections:indexes];
                } completion:nil];
            } @catch (NSException *exception) {
                NSLog(@"exception: %@", exception);
            }
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
    [self observeCollectionView:self.feedsCollectionView endOfFeeds:self.viewModel];
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
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    if (self.viewModel.feedsArray.count == 0) {
        [self showLoading];
        [self.viewModel requestData];
    }
    
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
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.weakTimer invalidate];
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

- (void)dealloc
{
    [self unobserve];
    [self.weakTimer invalidate];
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

- (void)categoryDidSelect:(PGCategoryIcon *)category
{
    PGStoreCategoryViewController *categoryVC = [[PGStoreCategoryViewController alloc] initWithCategoryId:category.categoryId];
    [self.navigationController pushViewController:categoryVC animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id banner = self.viewModel.feedsArray[indexPath.section];
    
    if ([banner isKindOfClass:[PGTopicBanner class]]) {
        PGTopicBanner *topicBanner = (PGTopicBanner *)banner;
        [[PGRouter sharedInstance] openURL:topicBanner.link];
    }
}

- (void)shouldPreloadNextPage
{
    PGWeakSelf(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [weakself.viewModel loadNextPage];
    });
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

#pragma mark - <Lazy Init>

- (PGFeedsCollectionView *)feedsCollectionView {
    if(_feedsCollectionView == nil) {
        _feedsCollectionView = [[PGFeedsCollectionView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT-50) collectionViewLayout:[UICollectionViewFlowLayout new]];
        _feedsCollectionView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
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

//- (PGNavigationView *)naviView
//{
//    if (!_naviView) {
//        _naviView = [PGNavigationView defaultNavigationView];
//    }
//    return _naviView;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
