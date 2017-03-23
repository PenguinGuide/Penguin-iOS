//
//  PGScenarioFeedsViewController.m
//  Penguin
//
//  Created by Jing Dai on 02/12/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//


#import "PGScenarioFeedsViewController.h"
#import "PGScenarioFeedsViewModel.h"
#import "PGScenarioFeedsCollectionView.h"
#import "PGArticleViewController.h"

@interface PGScenarioFeedsViewController () <PGFeedsCollectionViewDelegate>

@property (nonatomic, strong) PGFeedsCollectionView *feedsCollectionView;

@property (nonatomic, strong) PGScenarioFeedsViewModel *viewModel;

@property (nonatomic, strong) NSString *scenarioId;

@end

@implementation PGScenarioFeedsViewController

- (id)initWithScenarioId:(NSString *)scenarioId
{
    if (self = [super init]) {
        self.scenarioId = scenarioId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.feedsCollectionView];
    
    self.viewModel = [[PGScenarioFeedsViewModel alloc] initWithAPIClient:self.apiClient];
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"feedsArray" block:^(id changedObject) {
        NSArray *feedsArray = changedObject;
        if (feedsArray && [feedsArray isKindOfClass:[NSArray class]]) {
            [UIView setAnimationsEnabled:NO];
            [weakself.feedsCollectionView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView setAnimationsEnabled:YES];
            });
        }
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(dismissPageLoading)]) {
            [weakself.delegate dismissPageLoading];
        }
        [weakself.feedsCollectionView endBottomRefreshing];
    }];
    [self observe:self.viewModel keyPath:@"error" block:^(id changedObject) {
        [weakself showErrorMessage:weakself.viewModel.error];
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(dismissPageLoading)]) {
            [weakself.delegate dismissPageLoading];
        }
        [weakself.feedsCollectionView endBottomRefreshing];
    }];
    [self observeCollectionView:self.feedsCollectionView endOfFeeds:self.viewModel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadView];
}

- (void)reloadView
{
    if (self.viewModel.feedsArray.count == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(showPageLoading)]) {
            [self.delegate showPageLoading];
        }
        [self.viewModel requestFeeds:self.scenarioId];
    }
}

#pragma mark - <PGFeedsCollectionViewDelegate>

- (NSString *)pageName
{
    return @"scenario";
}

- (NSArray *)feedsArray
{
    return self.viewModel.feedsArray;
}

- (UIEdgeInsets)topEdgeInsets
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
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

#pragma mark - <Lazy Init>

- (PGFeedsCollectionView *)feedsCollectionView
{
    if (!_feedsCollectionView) {
        _feedsCollectionView = [[PGFeedsCollectionView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT-64-50) collectionViewLayout:[UICollectionViewFlowLayout new]];
        _feedsCollectionView.feedsDelegate = self;
        _feedsCollectionView.showsHorizontalScrollIndicator = NO;
        _feedsCollectionView.showsVerticalScrollIndicator = NO;
        _feedsCollectionView.backgroundColor = [UIColor whiteColor];
        _feedsCollectionView.allowGesture = NO;
        
        PGWeakSelf(self);
        [_feedsCollectionView enableInfiniteScrolling:^{
            [weakself.viewModel requestFeeds:weakself.scenarioId];
        }];
    }
    return _feedsCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
