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
@property (nonatomic, strong) PGBaseCollectionView *articlesCollectionView;
@property (nonatomic, strong) PGBaseCollectionView *goodsCollectionView;

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
        if (weakself.viewModel.articlesNextPageIndexes || weakself.viewModel.articlesNextPageIndexes.count > 0) {
            @try {
                [weakself.articlesCollectionView insertItemsAtIndexPaths:weakself.viewModel.articlesNextPageIndexes];
            } @catch (NSException *exception) {
                NSLog(@"exception: %@", exception);
            }
        } else {
            NSArray *bannersArray = changedObject;
            if (bannersArray && [bannersArray isKindOfClass:[NSArray class]]) {
                [weakself.articlesCollectionView reloadData];
            }
        }
        [weakself dismissLoading];
        [weakself.articlesCollectionView endBottomRefreshing];
    }];
    [self observe:self.viewModel keyPath:@"goods" block:^(id changedObject) {
        if (weakself.viewModel.goodsNextPageIndexes || weakself.viewModel.goodsNextPageIndexes.count > 0) {
            @try {
                [weakself.goodsCollectionView insertItemsAtIndexPaths:weakself.viewModel.goodsNextPageIndexes];
            } @catch (NSException *exception) {
                NSLog(@"exception: %@", exception);
            }
        } else {
            NSArray *bannersArray = changedObject;
            if (bannersArray && [bannersArray isKindOfClass:[NSArray class]]) {
                [weakself.goodsCollectionView reloadData];
            }
        }
        [weakself dismissLoading];
        [weakself.goodsCollectionView endBottomRefreshing];
    }];
    [self observe:self.viewModel keyPath:@"articlesEndFlag" block:^(id changedObject) {
        BOOL endFlag = [changedObject boolValue];
        if (endFlag) {
            [weakself.articlesCollectionView disableInfiniteScrolling];
            [[weakself.articlesCollectionView collectionViewLayout] invalidateLayout];
        } else {
            [weakself.articlesCollectionView enableInfiniteScrolling];
        }
    }];
    [self observe:self.viewModel keyPath:@"goodsEndFlag" block:^(id changedObject) {
        BOOL endFlag = [changedObject boolValue];
        if (endFlag) {
            [weakself.goodsCollectionView disableInfiniteScrolling];
            [[weakself.goodsCollectionView collectionViewLayout] invalidateLayout];
        } else {
            [weakself.goodsCollectionView enableInfiniteScrolling];
        }
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

#pragma mark - <UICollectionView>

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
        if (self.viewModel.articles.count-indexPath.item == 2) {
            PGWeakSelf(self);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [weakself.viewModel searchArticles:self.keyword];
            });
        }
        PGSearchResultsArticleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleCell forIndexPath:indexPath];
        [cell setCellWithArticle:self.viewModel.articles[indexPath.item]];
        
        return cell;
    } else {
        if (self.viewModel.goods.count-indexPath.item == 2) {
            PGWeakSelf(self);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [weakself.viewModel searchGoods:self.keyword];
            });
        }
        PGSingleGoodBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodCell forIndexPath:indexPath];
        [cell setCellWithSingleGood:self.viewModel.goods[indexPath.item]];
        
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == ArticlesCollectionViewTag) {
        return [PGSearchResultsArticleCell cellSize];
    } else {
        return [PGSingleGoodBannerCell cellSize];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (collectionView.tag == ArticlesCollectionViewTag) {
        if (self.viewModel.articlesEndFlag) {
            return [PGBaseCollectionViewFooterView footerViewSize];
        }
    } else {
        if (self.viewModel.goodsEndFlag) {
            return [PGBaseCollectionViewFooterView footerViewSize];
        }
    }
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    PGBaseCollectionViewFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BaseCollectionViewFooterView forIndexPath:indexPath];
    footerView.backgroundColor = Theme.colorBackground;
    
    return footerView;
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

- (void)searchButtonClicked:(NSString *)keyword
{
    self.keyword = keyword;
    [self.viewModel clearViewModel];
    
    if (!self.articlesCollectionView.hidden) {
        [self.viewModel searchArticles:self.keyword];
    } else {
        [self.viewModel searchGoods:self.keyword];
    }
}

#pragma mark - <Lazy Init>

- (PGBaseCollectionView *)articlesCollectionView {
	if(_articlesCollectionView == nil) {
		_articlesCollectionView = [[PGBaseCollectionView alloc] initWithFrame:CGRectMake(0, 94, UISCREEN_WIDTH, UISCREEN_HEIGHT-94) collectionViewLayout:[UICollectionViewFlowLayout new]];
        _articlesCollectionView.backgroundColor = Theme.colorBackground;
        _articlesCollectionView.tag = ArticlesCollectionViewTag;
        _articlesCollectionView.dataSource = self;
        _articlesCollectionView.delegate = self;
        _articlesCollectionView.showsHorizontalScrollIndicator = NO;
        _articlesCollectionView.showsVerticalScrollIndicator = NO;
        
        [_articlesCollectionView registerClass:[PGSearchResultsArticleCell class] forCellWithReuseIdentifier:ArticleCell];
        
        PGWeakSelf(self);
        [_articlesCollectionView enableInfiniteScrolling:^{
            [weakself.viewModel searchArticles:weakself.keyword];
        }];
	}
	return _articlesCollectionView;
}

- (PGBaseCollectionView *)goodsCollectionView {
	if(_goodsCollectionView == nil) {
		_goodsCollectionView = [[PGBaseCollectionView alloc] initWithFrame:CGRectMake(0, 94, UISCREEN_WIDTH, UISCREEN_HEIGHT-94) collectionViewLayout:[UICollectionViewFlowLayout new]];
        _goodsCollectionView.backgroundColor = Theme.colorBackground;
        _goodsCollectionView.tag = GoodsCollectionViewTag;
        _goodsCollectionView.dataSource = self;
        _goodsCollectionView.delegate = self;
        _goodsCollectionView.showsHorizontalScrollIndicator = NO;
        _goodsCollectionView.showsVerticalScrollIndicator = NO;
        
        [_goodsCollectionView registerClass:[PGSingleGoodBannerCell class] forCellWithReuseIdentifier:GoodCell];
        
        PGWeakSelf(self);
        [_goodsCollectionView enableInfiniteScrolling:^{
            [weakself.viewModel searchGoods:weakself.keyword];
        }];
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
