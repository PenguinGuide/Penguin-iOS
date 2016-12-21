//
//  PGSearchResultsArticlesViewController.m
//  Penguin
//
//  Created by Kobe Dai on 15/12/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define ArticleCell @"ArticleCell"

#import "PGSearchResultsArticlesViewController.h"

#import "PGSearchResultsArticlesViewModel.h"

#import "PGArticleBannerCell.h"

@interface PGSearchResultsArticlesViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PGArticleBannerCellDelegate>

@property (nonatomic, strong) NSString *keyword;

@property (nonatomic, strong) PGBaseCollectionView *articlesCollectionView;

@property (nonatomic, strong) PGSearchResultsArticlesViewModel *viewModel;

@end

@implementation PGSearchResultsArticlesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.articlesCollectionView];
    
    self.viewModel = [[PGSearchResultsArticlesViewModel alloc] initWithAPIClient:self.apiClient];
    
    PGWeakSelf(self);
    
    [self observe:self.viewModel keyPath:@"articlesArray" block:^(id changedObject) {
        NSArray *articlesArray = changedObject;
        if (articlesArray && [articlesArray isKindOfClass:[NSArray class]]) {
            [UIView setAnimationsEnabled:NO];
            [weakself.articlesCollectionView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView setAnimationsEnabled:YES];
            });
        }
        [weakself dismissLoading];
        [weakself.articlesCollectionView endBottomRefreshing];
    }];
    [self observeCollectionView:self.articlesCollectionView endOfFeeds:self.viewModel];
}

- (id)initWithKeyword:(NSString *)keyword
{
    if (self = [super init]) {
        self.keyword = keyword;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.viewModel.articlesArray.count == 0) {
        [self showLoading];
        [self.viewModel requestArticles:self.keyword];
    }
}

- (void)dealloc
{
    if (self.isViewLoaded) {
        [self unobserve];
    }
}

- (void)reloadWithKeyword:(NSString *)keyword
{
    self.keyword = keyword;
    [self.viewModel clearPagination];
    [self.viewModel requestArticles:self.keyword];
}

#pragma mark - <UICollectionView>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.articlesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.viewModel.articlesArray.count-indexPath.item == 2) {
        PGWeakSelf(self);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [weakself.viewModel requestArticles:self.keyword];
        });
    }
    PGArticleBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleCell forIndexPath:indexPath];
    [cell setDelegate:self];
    [cell setCellWithArticle:self.viewModel.articlesArray[indexPath.item]  allowGesture:YES];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [PGArticleBannerCell cellSize];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (!self.viewModel) {
        return CGSizeZero;
    }
    if (self.viewModel.endFlag) {
        return [PGBaseCollectionViewFooterView footerViewSize];
    }
    
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionFooter) {
        if (indexPath.section == 0) {
            PGBaseCollectionViewFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BaseCollectionViewFooterView forIndexPath:indexPath];
            
            return footerView;
        }
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGArticleBanner *articleBanner = self.viewModel.articlesArray[indexPath.item];
    [PGRouterManager routeToArticlePage:articleBanner.articleId link:articleBanner.link];
}

#pragma mark - <PGArticleBannerCellDelegate>

- (void)collectArticle:(PGArticleBanner *)article
{
    PGWeakSelf(self);
    __weak PGArticleBanner *weakArticle = article;
    [self.viewModel collectArticle:article.articleId completion:^(BOOL success) {
        if (success) {
            weakArticle.isCollected = YES;
            [weakself showToast:@"收藏成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:PG_NOTIFICATION_UPDATE_ME object:nil];
        }
    }];
}

- (void)disCollectArticle:(PGArticleBanner *)article
{
    PGWeakSelf(self);
    __weak PGArticleBanner *weakArticle = article;
    [self.viewModel disCollectArticle:article.articleId completion:^(BOOL success) {
        if (success) {
            weakArticle.isCollected = NO;
            [weakself showToast:@"取消成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:PG_NOTIFICATION_UPDATE_ME object:nil];
        }
    }];
}

#pragma mark - <Lazy Init>

- (PGBaseCollectionView *)articlesCollectionView
{
    if (!_articlesCollectionView) {
        _articlesCollectionView = [[PGBaseCollectionView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT-60-60) collectionViewLayout:[UICollectionViewFlowLayout new]];
        _articlesCollectionView.backgroundColor = [UIColor whiteColor];
        _articlesCollectionView.dataSource = self;
        _articlesCollectionView.delegate = self;
        
        [_articlesCollectionView registerClass:[PGArticleBannerCell class] forCellWithReuseIdentifier:ArticleCell];
        
        PGWeakSelf(self);
        [_articlesCollectionView enableInfiniteScrolling:^{
            [weakself.viewModel requestArticles:weakself.keyword];
        }];
    }
    return _articlesCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
