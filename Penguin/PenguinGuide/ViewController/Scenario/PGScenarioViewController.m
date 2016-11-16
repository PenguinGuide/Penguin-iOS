//
//  PGScenarioViewController.m
//  Penguin
//
//  Created by Jing Dai on 8/30/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGScenarioViewController.h"
#import "PGArticleViewController.h"

#import "PGScenarioViewModel.h"

#import "UIScrollView+PGScrollView.h"

#import "PGFeedsCollectionView.h"
#import "PGChannelCategoriesView.h"

@interface PGScenarioViewController () <PGFeedsCollectionViewDelegate, PGChannelCategoriesViewDelegate>

@property (nonatomic, strong) PGScenarioViewModel *viewModel;

@property (nonatomic, strong) NSString *scenarioId;

@property (nonatomic, strong) PGFeedsCollectionView *feedsCollectionView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) PGChannelCategoriesView *categoriesView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGFloat lastContentOffsetY;

@end

@implementation PGScenarioViewController

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
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.feedsCollectionView];
    [self.view addSubview:self.categoriesView];
    [self.view addSubview:self.backButton];
    
    self.viewModel = [[PGScenarioViewModel alloc] initWithAPIClient:self.apiClient];
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"feedsArray" block:^(id changedObject) {
        NSArray *feedsArray = changedObject;
        if (feedsArray && [feedsArray isKindOfClass:[NSArray class]]) {
            [weakself.categoriesView reloadViewWithCategories:weakself.viewModel.scenario.categoriesArray];
            [weakself.feedsCollectionView reloadData];
            
            weakself.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_WIDTH*9/16)];
            [weakself.imageView setWithImageURL:self.viewModel.scenario.image placeholder:nil completion:nil];
            [weakself.feedsCollectionView setHeaderView:self.imageView naviTitle:self.viewModel.scenario.title rightNaviButton:nil];
        }
        [weakself dismissLoading];
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
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    [self unobserve];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <PGFeedsCollectionViewDelegate>

- (NSArray *)recommendsArray
{
    return [NSArray new];
}

- (NSArray *)feedsArray
{
    return self.viewModel.feedsArray;
}

- (CGSize)feedsHeaderSize
{
    return CGSizeZero;
}

- (NSString *)tabType
{
    return @"scenario";
}

- (UIEdgeInsets)topEdgeInsets
{
    return UIEdgeInsetsMake(UISCREEN_WIDTH*9/16+61, 0, 7, 0);
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
        self.categoriesView.frame = CGRectMake(0, 64, UISCREEN_WIDTH, 61);
    } else {
        self.categoriesView.frame = CGRectMake(0, UISCREEN_WIDTH*9/16+(self.lastContentOffsetY-scrollView.contentOffset.y), UISCREEN_WIDTH, 61);
    }
}

#pragma mark - <PGChannelCategoriesViewDelegate>

- (void)scenarioCategoryDidSelect:(PGScenarioCategory *)category
{
    if (category.categoryId && category.categoryId.length > 0) {
        [self showLoading];
        [self.viewModel requestFeeds:self.viewModel.scenario.scenarioId categoryId:category.categoryId];
    } else {
        [self showLoading];
        [self.viewModel requestFeeds:self.viewModel.scenario.scenarioId categoryId:nil];
    }
}

#pragma mark - <Lazy Init>

- (PGFeedsCollectionView *)feedsCollectionView {
	if(_feedsCollectionView == nil) {
		_feedsCollectionView = [[PGFeedsCollectionView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT) collectionViewLayout:[UICollectionViewFlowLayout new]];
        _feedsCollectionView.feedsDelegate = self;
	}
	return _feedsCollectionView;
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

- (PGChannelCategoriesView *)categoriesView {
	if(_categoriesView == nil) {
		_categoriesView = [[PGChannelCategoriesView alloc] initWithFrame:CGRectMake(0, UISCREEN_WIDTH*9/16, UISCREEN_WIDTH, 61)];
        _categoriesView.delegate = self;
	}
	return _categoriesView;
}

@end
