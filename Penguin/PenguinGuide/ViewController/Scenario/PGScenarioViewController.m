//
//  PGScenarioViewController.m
//  Penguin
//
//  Created by Jing Dai on 8/30/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define CarouselBannerCell @"CarouselBannerCell"
#define ArticleBannerCell @"ArticleBannerCell"
#define GoodsCollectionBannerCell @"GoodsCollectionBannerCell"
#define TopicBannerCell @"TopicBannerCell"
#define SingleGoodBannerCell @"SingleGoodBannerCell"
#define FlashbuyBannerCell @"FlashbuyBannerCell"
#define GoodCell @"GoodCell"

#import "PGScenarioViewController.h"
#import "PGArticleViewController.h"

#import "PGScenarioViewModel.h"

#import "UIScrollView+PGScrollView.h"
#import "MSWeakTimer.h"

#import "PGFeedsCollectionView.h"
#import "PGChannelCategoriesView.h"
#import "PGGoodCell.h"

@interface PGScenarioViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) PGScenarioViewModel *viewModel;

@property (nonatomic, strong) NSString *scenarioId;

@property (nonatomic, strong) PGBaseCollectionView *scenarioCollectionView;

@property (nonatomic, strong) UIView *segmentView;
@property (nonatomic, strong) UIButton *allButton;
@property (nonatomic, strong) UIButton *goodsButton;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGFloat lastContentOffsetY;

@property (nonatomic, strong) MSWeakTimer *weakTimer;

@property (nonatomic, assign) BOOL statusbarIsLight;

@end

@implementation PGScenarioViewController

- (id)initWithScenarioId:(NSString *)scenarioId
{
    if (self = [super init]) {
        self.scenarioId = scenarioId;
        self.statusbarIsLight = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.scenarioCollectionView];
    [self.view addSubview:self.backButton];
    
    self.viewModel = [[PGScenarioViewModel alloc] initWithAPIClient:self.apiClient];
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"feedsArray" block:^(id changedObject) {
        NSArray *feedsArray = changedObject;
        if (feedsArray && [feedsArray isKindOfClass:[NSArray class]]) {
            [UIView setAnimationsEnabled:NO];
            [weakself.scenarioCollectionView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView setAnimationsEnabled:YES];
            });
            
            if (!weakself.imageView) {
                weakself.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_WIDTH*9/16)];
                weakself.imageView.clipsToBounds = YES;
                [weakself.imageView setWithImageURL:self.viewModel.scenario.image placeholder:nil completion:nil];
                [weakself.scenarioCollectionView setHeaderView:self.imageView naviTitle:self.viewModel.scenario.title rightNaviButton:nil];
            }
            
            if (!weakself.segmentView.superview) {
                weakself.segmentView.frame = CGRectMake(0, UISCREEN_WIDTH*9/16, UISCREEN_WIDTH, 50);
                [weakself.view addSubview:weakself.segmentView];
            }
        }
        [weakself dismissLoading];
        [weakself.scenarioCollectionView endBottomRefreshing];
    }];
    [self observe:self.viewModel keyPath:@"goodsArray" block:^(id changedObject) {
        NSArray *goodsArray = changedObject;
        if (goodsArray && [goodsArray isKindOfClass:[NSArray class]]) {
            [weakself.scenarioCollectionView reloadData];
        }
        [weakself dismissLoading];
        [weakself.scenarioCollectionView endBottomRefreshing];
    }];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    if (self.viewModel.feedsArray.count == 0) {
        [self showLoading];
        [self.viewModel requestScenario:self.scenarioId];
    }
    
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

- (void)dealloc
{
    [self unobserve];
    [self.weakTimer invalidate];
    self.weakTimer = nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.statusbarIsLight ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UICollectionView>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (collectionView.tag == 0) {
        return self.viewModel.feedsArray.count;
    } else {
        return 1;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag == 0) {
        return 1;
    } else {
        return self.viewModel.goodsArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 0) {
        id banner = self.viewModel.feedsArray[indexPath.section];
        
        if ([banner isKindOfClass:[PGCarouselBanner class]]) {
            PGCarouselBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CarouselBannerCell forIndexPath:indexPath];
            
            PGCarouselBanner *carouselBanner = (PGCarouselBanner *)banner;
            [cell reloadBannersWithData:carouselBanner.banners];
            
            return cell;
        } else if ([banner isKindOfClass:[PGArticleBanner class]]) {
            PGArticleBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleBannerCell forIndexPath:indexPath];
            
            PGArticleBanner *articleBanner = (PGArticleBanner *)banner;
            [cell setCellWithArticle:articleBanner allowGesture:YES];
            
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
    } else {
        PGGoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodCell forIndexPath:indexPath];
        
        [cell setCellWithGood:self.viewModel.goodsArray[indexPath.item]];
        
        return cell;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 0) {
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
    } else {
        return [PGGoodCell cellSize];
    }
    
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (collectionView.tag == 0) {
        if (section == 0) {
            return UIEdgeInsetsMake(UISCREEN_WIDTH*9/16+50, 0, 0, 0);
        }
        id banner = self.viewModel.feedsArray[section];
        if (section == self.viewModel.feedsArray.count-1) {
            return UIEdgeInsetsMake(15, 0, 0, 0);
        } else if ([banner isKindOfClass:[PGArticleBanner class]]) {
            if (section == 0) {
                id nextBanner = self.viewModel.feedsArray[section+1];
                if ([nextBanner isKindOfClass:[PGArticleBanner class]]) {
                    return UIEdgeInsetsMake(15, 0, 0, 0);
                } else {
                    return UIEdgeInsetsMake(15, 0, 15, 0);
                }
            } else if (section+1 < self.viewModel.feedsArray.count) {
                id nextBanner = self.viewModel.feedsArray[section+1];
                if ([nextBanner isKindOfClass:[PGArticleBanner class]]) {
                    return UIEdgeInsetsZero;
                } else {
                    return UIEdgeInsetsMake(0, 0, 15, 0);
                }
            } else {
                return UIEdgeInsetsZero;
            }
        } else {
            if (section == 0) {
                return UIEdgeInsetsMake(15, 0, 15, 0);
            } else {
                return UIEdgeInsetsMake(0, 0, 15, 0);
            }
        }
        return UIEdgeInsetsZero;
    } else {
        return UIEdgeInsetsMake(10, 8, 10, 8);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (collectionView.tag == 0) {
        return 0.f;
    } else {
        return 10.f;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (collectionView.tag == 0) {
        return 0.f;
    } else {
        return 11.f;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id banner = self.viewModel.feedsArray[indexPath.section];
    if ([banner isKindOfClass:[PGArticleBanner class]]) {
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [scrollView scrollViewShouldUpdate];
    if (UISCREEN_WIDTH*9/16-scrollView.contentOffset.y <= 64) {
        self.segmentView.frame = CGRectMake(0, 64, UISCREEN_WIDTH, 50);
        [self.backButton setImage:[UIImage imageNamed:@"pg_navigation_back_button"] forState:UIControlStateNormal];
        
        if (self.statusbarIsLight) {
            self.statusbarIsLight = NO;
            [self setNeedsStatusBarAppearanceUpdate];
        } else {
            self.statusbarIsLight = NO;
        }
    } else {
        self.segmentView.frame = CGRectMake(0, UISCREEN_WIDTH*9/16+(self.lastContentOffsetY-scrollView.contentOffset.y), UISCREEN_WIDTH, 50);
        [self.backButton setImage:[UIImage imageNamed:@"pg_navigation_back_button_light"] forState:UIControlStateNormal];
        
        if (!self.statusbarIsLight) {
            self.statusbarIsLight = YES;
            [self setNeedsStatusBarAppearanceUpdate];
        } else {
            self.statusbarIsLight = YES;
        }
    }
}

#pragma mark - <Button Events>

- (void)allButtonClicked
{
    self.allButton.selected = YES;
    self.goodsButton.selected = NO;
    
    self.scenarioCollectionView.tag = 0;
    
    if (self.viewModel.feedsArray.count == 0) {
        [self.viewModel requestFeeds];
    } else {
        [self.scenarioCollectionView reloadData];
    }
}

- (void)goodsButtonClicked
{
    self.allButton.selected = NO;
    self.goodsButton.selected = YES;
    
    self.scenarioCollectionView.tag = 1;
    
    if (self.viewModel.goodsArray.count == 0) {
        [self.viewModel requestGoods];
    } else {
        [self.scenarioCollectionView reloadData];
    }
}

- (void)countdown
{
    if (self.scenarioCollectionView.tag == 0) {
        for (UICollectionViewCell *visibleCell in self.scenarioCollectionView.visibleCells) {
            if ([visibleCell isKindOfClass:[PGFlashbuyBannerCell class]]) {
                PGFlashbuyBannerCell *cell = (PGFlashbuyBannerCell *)visibleCell;
                NSInteger index = [[self.scenarioCollectionView indexPathForCell:cell] section];
                if (index < self.viewModel.feedsArray.count) {
                    PGFlashbuyBanner *flashbuy = self.viewModel.feedsArray[index];
                    if (flashbuy && [flashbuy isKindOfClass:[PGFlashbuyBanner class]] && cell) {
                        [cell countdown:flashbuy];
                    }
                }
            }
        }
    }
}

#pragma mark - <Lazy Init>

- (UIView *)segmentView
{
    if (!_segmentView) {
        _segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 50)];
        _segmentView.backgroundColor = [UIColor whiteColor];
        
        self.allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH/2, 50)];
        [self.allButton setTitle:@"全 部" forState:UIControlStateNormal];
        [self.allButton setTitleColor:Theme.colorLightText forState:UIControlStateNormal];
        [self.allButton setTitleColor:Theme.colorText forState:UIControlStateSelected];
        [self.allButton addTarget:self action:@selector(allButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        self.goodsButton = [[UIButton alloc] initWithFrame:CGRectMake(UISCREEN_WIDTH/2, 02, UISCREEN_WIDTH/2, 50)];
        [self.goodsButton setTitle:@"商 品" forState:UIControlStateNormal];
        [self.goodsButton setTitleColor:Theme.colorLightText forState:UIControlStateNormal];
        [self.goodsButton setTitleColor:Theme.colorText forState:UIControlStateSelected];
        [self.goodsButton addTarget:self action:@selector(goodsButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        self.allButton.selected = YES;
        
        [_segmentView addSubview:self.allButton];
        [_segmentView addSubview:self.goodsButton];
    }
    return _segmentView;
}

- (PGBaseCollectionView *)scenarioCollectionView {
    if(_scenarioCollectionView == nil) {
        _scenarioCollectionView = [[PGBaseCollectionView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT) collectionViewLayout:[UICollectionViewFlowLayout new]];
        _scenarioCollectionView.dataSource = self;
        _scenarioCollectionView.delegate = self;
        _scenarioCollectionView.showsHorizontalScrollIndicator = NO;
        _scenarioCollectionView.showsVerticalScrollIndicator = NO;
        _scenarioCollectionView.backgroundColor = [UIColor whiteColor];
        
        [_scenarioCollectionView registerClass:[PGCarouselBannerCell class] forCellWithReuseIdentifier:CarouselBannerCell];
        [_scenarioCollectionView registerClass:[PGArticleBannerCell class] forCellWithReuseIdentifier:ArticleBannerCell];
        [_scenarioCollectionView registerClass:[PGGoodsCollectionBannerCell class] forCellWithReuseIdentifier:GoodsCollectionBannerCell];
        [_scenarioCollectionView registerClass:[PGTopicBannerCell class] forCellWithReuseIdentifier:TopicBannerCell];
        [_scenarioCollectionView registerClass:[PGSingleGoodBannerCell class] forCellWithReuseIdentifier:SingleGoodBannerCell];
        [_scenarioCollectionView registerClass:[PGFlashbuyBannerCell class] forCellWithReuseIdentifier:FlashbuyBannerCell];
        [_scenarioCollectionView registerClass:[PGGoodCell class] forCellWithReuseIdentifier:GoodCell];
        
        PGWeakSelf(self);
        __block PGBaseCollectionView *weakCollectionView = _scenarioCollectionView;
        [_scenarioCollectionView enableInfiniteScrolling:^{
            if (weakCollectionView.tag == 0) {
                [weakself.viewModel requestFeeds];
            } else {
                [weakself.viewModel requestGoods];
            }
        }];
    }
    return _scenarioCollectionView;
}

- (UIButton *)backButton {
	if(_backButton == nil) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(24, 35, 50, 50)];
        [_backButton setImage:[UIImage imageNamed:@"pg_navigation_back_button_light"] forState:UIControlStateNormal];
        [_backButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [_backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	}
	return _backButton;
}

@end
