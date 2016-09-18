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

@interface PGStoreViewController () <PGFeedsCollectionViewDelegate>

@property (nonatomic, strong) PGStoreViewModel *viewModel;
@property (nonatomic, strong) PGFeedsCollectionView *feedsCollectionView;

@end

@implementation PGStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.feedsCollectionView];
    
    self.viewModel = [[PGStoreViewModel alloc] initWithAPIClient:self.apiClient];
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
    // http://stackoverflow.com/questions/19411442/uicollectionview-adds-top-margin
    // ISSUE: put in setter doesn't work
    //self.feedsCollectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // ISSUE: if set to YES, scrollViewDidScroll will not be called (next page nothing to update)
    [self.navigationController setNavigationBarHidden:YES animated:NO];
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
    //PGLogWarning(@"store tabBarDidClicked");
    
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
    return [PGStoreRecommendsHeaderView headerViewSize];
}

- (NSString *)tabType
{
    return @"store";
}

- (void)categoryDidSelect:(PGCategoryIcon *)category
{
    PGStoreCategoryViewController *categoryVC = [[PGStoreCategoryViewController alloc] init];
    [self.navigationController pushViewController:categoryVC animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id banner = self.viewModel.bannersArray[indexPath.section];
    
    if ([banner isKindOfClass:[PGTopicBanner class]]) {
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
