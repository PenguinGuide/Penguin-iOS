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

#import "MSWeakTimer.h"

// view controllers
#import "PGHomeViewController.h"
#import "PGLoginViewController.h"
#import "PGArticleViewController.h"
#import "PGChannelViewController.h"
#import "PGSearchRecommendsViewController.h"
// view models
#import "PGHomeViewModel.h"
// views
#import "PGHomeRecommendsHeaderView.h"

@interface PGHomeViewController () <PGFeedsCollectionViewDelegate>

@property (nonatomic, strong) PGHomeViewModel *viewModel;
@property (nonatomic, strong, readwrite) PGFeedsCollectionView *feedsCollectionView;

@property (nonatomic, strong) UIButton *searchButton;

@property (nonatomic, strong) MSWeakTimer *weakTimer;

@property (nonatomic, assign) BOOL statusbarIsWhiteBackground;

@end

@implementation PGHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageView = @"首页";
    
    self.parentViewController.navigationItem.leftBarButtonItem = nil;
    self.parentViewController.navigationItem.titleView = nil;
    
    [self.view addSubview:self.feedsCollectionView];
    [self.view addSubview:self.searchButton];
    
    self.viewModel = [[PGHomeViewModel alloc] initWithAPIClient:self.apiClient];
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"feedsArray" block:^(id changedObject) {
        if (weakself.viewModel.nextPageIndexSet || weakself.viewModel.nextPageIndexSet.count > 0) {
            @try {
                // NOTE: using insertItemsAtIndexPaths will crash -- this should insert sections
                /*
                 exception: Invalid update: invalid number of sections. The number of sections contained in the collection view after the
                 update (20) must be equal to the number of sections contained in the collection view before the update (31),
                 plus or minus the number of sections inserted or deleted (10 inserted, 0 deleted).
                 */
                // NOTE: the number of sections inserted + number of sections in previous collection view = [collectionView numberOfSections]
                [weakself.feedsCollectionView insertSections:weakself.viewModel.nextPageIndexSet];
            } @catch (NSException *exception) {
                NSLog(@"exception: %@", exception);
            }
        } else {
            NSArray *feedsArray = changedObject;
            if (feedsArray && [feedsArray isKindOfClass:[NSArray class]]) {
                [weakself.feedsCollectionView reloadData];
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

- (void)dealloc
{
    [self unobserve];
    [self.weakTimer invalidate];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    // http://blog.csdn.net/ws1352864983/article/details/51932388
    // http://www.appcoda.com/customize-navigation-status-bar-ios-7/
    // http://tech.glowing.com/cn/change-uinavigationbar-backgroundcolor-dynamically/
    
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
    return self.viewModel.channelsArray;
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
    return [PGHomeRecommendsHeaderView headerViewSize];
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
    return @"home";
}

- (void)channelDidSelect:(NSString *)link
{
    [[PGRouter sharedInstance] openURL:link];
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
        PGArticleViewController *articleVC = [[PGArticleViewController alloc] initWithArticleId:articleBanner.articleId animated:YES];
        [self.navigationController pushViewController:articleVC animated:YES];
    } else if ([banner isKindOfClass:[PGTopicBanner class]]) {
        PGTopicBanner *topicBanner = (PGTopicBanner *)banner;
        [[PGRouter sharedInstance] openURL:topicBanner.link];
    } else if ([banner isKindOfClass:[PGSingleGoodBanner class]]) {
        PGSingleGoodBanner *singleGoodBanner = (PGSingleGoodBanner *)banner;
        [[PGRouter sharedInstance] openURL:singleGoodBanner.link];
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
        self.searchButton.hidden = YES;
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
        self.searchButton.hidden = NO;
    }
}

- (void)shouldPreloadNextPage
{
    PGWeakSelf(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [weakself.viewModel requestFeeds];
    });
}

#pragma mark - <Button Events>

- (void)searchButtonClicked
{
    PGSearchRecommendsViewController *searchRecommendsVC = [[PGSearchRecommendsViewController alloc] init];
    PGBaseNavigationController *naviController = [[PGBaseNavigationController alloc] initWithRootViewController:searchRecommendsVC];
    [self presentViewController:naviController animated:NO completion:nil];
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

#pragma mark - <Setters && Getters>

- (UIButton *)searchButton
{
    if (!_searchButton) {
        _searchButton = [[UIButton alloc] initWithFrame:CGRectMake(24, 35, 50, 50)];
        [_searchButton setImage:[UIImage imageNamed:@"pg_home_search_button"] forState:UIControlStateNormal];
        [_searchButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [_searchButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_searchButton addTarget:self action:@selector(searchButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchButton;
}

- (PGFeedsCollectionView *)feedsCollectionView
{
    if (!_feedsCollectionView) {
        _feedsCollectionView = [[PGFeedsCollectionView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT-50) collectionViewLayout:[UICollectionViewFlowLayout new]];
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
            [weakself.viewModel requestFeeds];
        }];
    }
    return _feedsCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
