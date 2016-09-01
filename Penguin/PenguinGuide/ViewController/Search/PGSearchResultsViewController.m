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
    [self.viewModel searchArticles:@""];
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"articlesArray" block:^(id changedObject) {
        NSArray *bannersArray = changedObject;
        if (bannersArray && [bannersArray isKindOfClass:[NSArray class]]) {
            [weakself.articlesCollectionView reloadData];
        }
    }];
    [self observe:self.viewModel keyPath:@"goodsArray" block:^(id changedObject) {
        NSArray *bannersArray = changedObject;
        if (bannersArray && [bannersArray isKindOfClass:[NSArray class]]) {
            [weakself.goodsCollectionView reloadData];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
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
        return self.viewModel.articlesArray.count;
    } else {
        return self.viewModel.goodsArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == ArticlesCollectionViewTag) {
        PGSearchResultsArticleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleCell forIndexPath:indexPath];
        [cell setCellWithArticle:self.viewModel.articlesArray[indexPath.item]];
        
        return cell;
    } else {
        PGSingleGoodBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodCell forIndexPath:indexPath];
        [cell setCellWithSingleGood:self.viewModel.goodsArray[indexPath.item]];
        
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

#pragma mark - <PGSearchResultsHeaderViewDelegate>

- (void)segmentDidClicked:(NSInteger)index
{
    if (index == 0) {
        if (self.viewModel.articlesArray.count == 0) {
            [self.viewModel searchArticles:@""];
            [self.articlesCollectionView removeFromSuperview];
            [self.view addSubview:self.articlesCollectionView];
        } else {
            self.articlesCollectionView.hidden = NO;
            self.goodsCollectionView.hidden = YES;
        }
    } else if (index == 1) {
        if (self.viewModel.goodsArray.count == 0) {
            [self.viewModel searchGoods:@""];
            [self.goodsCollectionView removeFromSuperview];
            [self.view addSubview:self.goodsCollectionView];
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
        [_headerView setHeaderViewWithKeyword:self.keyword segments:@[@"文 章(78)", @"商 品(35)"]];
	}
	return _headerView;
}

@end
