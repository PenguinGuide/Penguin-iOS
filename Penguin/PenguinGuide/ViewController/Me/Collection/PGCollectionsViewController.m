//
//  PGCollectionsViewController.m
//  Penguin
//
//  Created by Jing Dai on 28/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define ArticleBannerCell @"ArticleBannerCell"

#import "PGCollectionsViewController.h"
#import "PGCollectionsContentViewController.h"
#import "PGCollectionContentViewModel.h"
#import "PGArticleBannerCell.h"

@interface PGCollectionsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PGArticleBannerCellDelegate>

@property (nonatomic, strong) PGBaseCollectionView *articlesCollectionView;

@property (nonatomic, strong) PGCollectionContentViewModel *viewModel;

@end

@implementation PGCollectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationTitle:@"我的收藏"];
    
    [self.view addSubview:self.articlesCollectionView];
    
    self.viewModel = [[PGCollectionContentViewModel alloc] initWithAPIClient:self.apiClient];
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"articles" block:^(id changedObject) {
        NSArray *articles = changedObject;
        if (articles && [articles isKindOfClass:[NSArray class]]) {
            [UIView setAnimationsEnabled:NO];
            [weakself.articlesCollectionView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView setAnimationsEnabled:YES];
            });
            
            if (articles.count == 0 && !weakself.viewModel.endFlag) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakself showPlaceholder:@"pg_collections_placeholder" desc:@"还没有喜欢的内容呢"];
                });
            }
        }
        [weakself dismissLoading];
        [weakself.articlesCollectionView endBottomRefreshing];
    }];
    [self observeError:self.viewModel];
    [self observeCollectionView:self.articlesCollectionView endOfFeeds:self.viewModel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.viewModel.articles.count == 0) {
        [self showLoading];
        [self.viewModel requestData];
    }
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.articles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGArticleBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleBannerCell forIndexPath:indexPath];
    
    PGArticleBanner *articleBanner = self.viewModel.articles[indexPath.item];
    articleBanner.isCollected = YES;
    [cell setDelegate:self];
    [cell setCellWithArticle:articleBanner allowGesture:YES];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [PGArticleBannerCell cellSize];
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

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionFooter) {
        PGBaseCollectionViewFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BaseCollectionViewFooterView forIndexPath:indexPath];
        return footerView;
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGArticleBanner *articleBanner = self.viewModel.articles[indexPath.item];
    [[PGRouter sharedInstance] openURL:articleBanner.link];
}

#pragma mark - <PGArticleBannerCellDelegate>

- (void)disCollectArticle:(PGArticleBanner *)article
{
    PGWeakSelf(self);
    __weak PGArticleBanner *weakArticle = article;
    [self.viewModel disCollectArticle:article.articleId completion:^(BOOL success) {
        if (success) {
            NSInteger index = [weakself.viewModel.articles indexOfObject:weakArticle];
            [weakself.articlesCollectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
            [weakself showToast:@"取消成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:PG_NOTIFICATION_UPDATE_ME object:nil];
        } else {
            [weakself showToast:@"取消失败"];
        }
    }];
}

#pragma mark - <Lazy Init>

- (PGBaseCollectionView *)articlesCollectionView
{
    if (!_articlesCollectionView) {
        _articlesCollectionView = [[PGBaseCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[UICollectionViewFlowLayout new]];
        _articlesCollectionView.dataSource = self;
        _articlesCollectionView.delegate = self;
        
        [_articlesCollectionView registerClass:[PGArticleBannerCell class] forCellWithReuseIdentifier:ArticleBannerCell];
        
        PGWeakSelf(self);
        [_articlesCollectionView enableInfiniteScrolling:^{
            [weakself.viewModel requestData];
        }];
    }
    return _articlesCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
