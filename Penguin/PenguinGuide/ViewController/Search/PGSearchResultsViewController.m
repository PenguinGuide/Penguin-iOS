//
//  PGSearchResultsViewController.m
//  Penguin
//
//  Created by Jing Dai on 8/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define ArticleCell @"ArticleCell"
#define GoodCell @"GoodCell"
#define ArticlesCollectionViewTag 1
#define GoodsCollectionViewTag 2

#import "PGSearchResultsViewController.h"
#import "PGArticleViewController.h"
#import "PGGoodViewController.h"

#import "PGSearchResultsViewModel.h"

#import "PGSearchResultsArticleCell.h"
#import "PGSingleGoodBannerCell.h"

#import "PGSearchResultsHeaderView.h"

@interface PGSearchResultsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PGSearchResultsHeaderViewDelegate>

@property (nonatomic, strong) NSString *keyword;

@property (nonatomic, strong) PGSearchResultsViewModel *viewModel;

@property (nonatomic, strong) PGSearchResultsHeaderView *headerView;
@property (nonatomic, strong) UICollectionView *articlesCollectionView;
@property (nonatomic, strong) UICollectionView *goodsCollectionView;

@end

@implementation PGSearchResultsViewController

- (id)initWithKeyword:(NSString *)keyword
{
    if (self = [super init]) {
        self.keyword = keyword;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = Theme.colorBackground;
    
    [self.view addSubview:self.articlesCollectionView];
    [self.view addSubview:self.headerView];
    
    self.viewModel = [[PGSearchResultsViewModel alloc] initWithAPIClient:self.apiClient];
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"articles" block:^(id changedObject) {
        NSArray *bannersArray = changedObject;
        if (bannersArray && [bannersArray isKindOfClass:[NSArray class]]) {
            [weakself.articlesCollectionView reloadData];
        }
        [weakself dismissLoading];
    }];
    [self observe:self.viewModel keyPath:@"goods" block:^(id changedObject) {
        NSArray *bannersArray = changedObject;
        if (bannersArray && [bannersArray isKindOfClass:[NSArray class]]) {
            [weakself.goodsCollectionView reloadData];
        }
        [weakself dismissLoading];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    if (self.articlesCollectionView) {
        if (self.viewModel.articles.count == 0) {
            [self showLoading];
            [self.viewModel searchArticles:self.keyword];
        }
    } else if (self.goodsCollectionView) {
        if (self.viewModel.goods.count == 0) {
            [self showLoading];
            [self.viewModel searchGoods:self.keyword];
        }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag == ArticlesCollectionViewTag) {
        return self.viewModel.articles.count;
    } else {
        return self.viewModel.goods.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == ArticlesCollectionViewTag) {
        PGSearchResultsArticleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleCell forIndexPath:indexPath];
        [cell setCellWithArticle:self.viewModel.articles[indexPath.item]];
        
        return cell;
    } else {
        PGSingleGoodBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodCell forIndexPath:indexPath];
        [cell setCellWithSingleGood:self.viewModel.goods[indexPath.item]];
        
        return cell;
    }
}

#pragma mark - <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == ArticlesCollectionViewTag) {
        return [PGSearchResultsArticleCell cellSize];
    } else {
        return [PGSingleGoodBannerCell cellSize];
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (collectionView.tag == ArticlesCollectionViewTag) {
        return 15.f;
    } else {
        return 10.f;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == ArticlesCollectionViewTag) {
        PGArticleBanner *articleBanner = self.viewModel.articles[indexPath.item];
        PGArticleViewController *articleVC = [[PGArticleViewController alloc] initWithArticleId:articleBanner.articleId animated:NO];
        [self.navigationController pushViewController:articleVC animated:YES];
    } else if (collectionView.tag == GoodsCollectionViewTag) {
        PGGood *good = self.viewModel.goods[indexPath.item];
        PGGoodViewController *goodVC = [[PGGoodViewController alloc] initWithGoodId:good.goodId];
        [self.navigationController pushViewController:goodVC animated:YES];
    }
}

#pragma mark - <PGSearchResultsHeaderViewDelegate>

- (void)segmentDidClicked:(NSInteger)index
{
    if (index == 0) {
        if (self.viewModel.articles.count == 0) {
            [self.articlesCollectionView removeFromSuperview];
            [self.view addSubview:self.articlesCollectionView];
            [self showLoading];
            [self.viewModel searchArticles:self.keyword];
        } else {
            self.articlesCollectionView.hidden = NO;
            self.goodsCollectionView.hidden = YES;
        }
    } else if (index == 1) {
        if (self.viewModel.goods.count == 0) {
            [self.goodsCollectionView removeFromSuperview];
            [self.view addSubview:self.goodsCollectionView];
            [self showLoading];
            [self.viewModel searchGoods:self.keyword];
        } else {
            self.articlesCollectionView.hidden = YES;
            self.goodsCollectionView.hidden = NO;
        }
    }
}

- (void)cancelButtonClicked
{
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UICollectionView *)articlesCollectionView {
	if(_articlesCollectionView == nil) {
		_articlesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 94, UISCREEN_WIDTH, UISCREEN_HEIGHT-94) collectionViewLayout:[UICollectionViewFlowLayout new]];
        _articlesCollectionView.backgroundColor = Theme.colorBackground;
        _articlesCollectionView.tag = ArticlesCollectionViewTag;
        _articlesCollectionView.dataSource = self;
        _articlesCollectionView.delegate = self;
        
        [_articlesCollectionView registerClass:[PGSearchResultsArticleCell class] forCellWithReuseIdentifier:ArticleCell];
	}
	return _articlesCollectionView;
}

- (UICollectionView *)goodsCollectionView {
	if(_goodsCollectionView == nil) {
		_goodsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 94, UISCREEN_WIDTH, UISCREEN_HEIGHT-94) collectionViewLayout:[UICollectionViewFlowLayout new]];
        _goodsCollectionView.backgroundColor = Theme.colorBackground;
        _goodsCollectionView.tag = GoodsCollectionViewTag;
        _goodsCollectionView.dataSource = self;
        _goodsCollectionView.delegate = self;
        
        [_goodsCollectionView registerClass:[PGSingleGoodBannerCell class] forCellWithReuseIdentifier:GoodCell];
	}
	return _goodsCollectionView;
}

- (PGSearchResultsHeaderView *)headerView {
	if(_headerView == nil) {
		_headerView = [[PGSearchResultsHeaderView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 94)];
        _headerView.delegate = self;
        [_headerView setHeaderViewWithKeyword:self.keyword segments:@[@"文 章", @"商 品"]];
	}
	return _headerView;
}

@end
