//
//  PGCityGuideArticlesViewController.m
//  Penguin
//
//  Created by Jing Dai on 28/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define ArticleBannerCell @"ArticleBannerCell"

#import "PGCityGuideArticlesViewController.h"
#import "PGCityGuideArticlesViewModel.h"
#import "PGArticleBannerCell.h"

@interface PGCityGuideArticlesViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong, readwrite) PGBaseCollectionView *articlesCollectionView;
@property (nonatomic, strong) PGCityGuideArticlesViewModel *viewModel;

@property (nonatomic, strong) NSString *cityId;

@end

@implementation PGCityGuideArticlesViewController

- (id)initWithCityId:(NSString *)cityId
{
    if (self = [super init]) {
        self.cityId = cityId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.articlesCollectionView];
    
    self.viewModel = [[PGCityGuideArticlesViewModel alloc] initWithAPIClient:self.apiClient];
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"articlesArray" block:^(id changedObject) {
        if (weakself.viewModel.nextPageIndexes || weakself.viewModel.nextPageIndexes.count > 0) {
            @try {
                [weakself.articlesCollectionView insertItemsAtIndexPaths:weakself.viewModel.nextPageIndexes];
            } @catch (NSException *exception) {
                NSLog(@"exception: %@", exception);
            }
        } else {
            NSArray *articlesArray = changedObject;
            if (articlesArray && [articlesArray isKindOfClass:[NSArray class]]) {
                [UIView setAnimationsEnabled:NO];
                [weakself.articlesCollectionView reloadData];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIView setAnimationsEnabled:YES];
                });
            }
        }
        [weakself dismissLoading];
        [weakself.articlesCollectionView endTopRefreshing];
        [weakself.articlesCollectionView endBottomRefreshing];
    }];
    [self observe:self.viewModel keyPath:@"error" block:^(id changedObject) {
        NSError *error = changedObject;
        if (error && [error isKindOfClass:[NSError class]]) {
            [weakself showErrorMessage:error];
            [weakself dismissLoading];
            [weakself.articlesCollectionView endTopRefreshing];
            [weakself.articlesCollectionView endBottomRefreshing];
        }
    }];
    [self observeCollectionView:self.articlesCollectionView endOfFeeds:self.viewModel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadView];
}

- (void)dealloc
{
    [self unobserve];
}

- (void)reloadView
{
    if (self.viewModel.articlesArray.count == 0) {
        [self showLoading];
        [self.viewModel requestArticles:self.cityId];
    }
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
    PGArticleBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleBannerCell forIndexPath:indexPath];
    
    PGArticleBanner *articleBanner = self.viewModel.articlesArray[indexPath.item];
    cell.eventName = article_banner_clicked;
    cell.eventId = articleBanner.articleId;
    cell.pageName = city_guide_tab_view;
    if (self.cityId) {
        cell.extraParams = @{@"city_id":self.cityId};
    }
    
    [cell setCellWithArticle:self.viewModel.articlesArray[indexPath.item] allowGesture:NO];
    
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
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
    [PGRouterManager routeToArticlePage:articleBanner.articleId link:articleBanner.link animated:NO];
}

#pragma mark - <Lazy Init>

- (PGBaseCollectionView *)articlesCollectionView {
    if(_articlesCollectionView == nil) {
        _articlesCollectionView = [[PGBaseCollectionView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT-50-20-60) collectionViewLayout:[UICollectionViewFlowLayout new]];
        _articlesCollectionView.backgroundColor = [UIColor whiteColor];
        _articlesCollectionView.dataSource = self;
        _articlesCollectionView.delegate = self;
        
        [_articlesCollectionView registerClass:[PGArticleBannerCell class] forCellWithReuseIdentifier:ArticleBannerCell];
        [_articlesCollectionView registerClass:[PGBaseCollectionViewFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:BaseCollectionViewFooterView];
        
        PGWeakSelf(self);
        [_articlesCollectionView enablePullToRefreshWithTopInset:0.f
                                                      completion:^{
                                                          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                              if ([weakself.cityId isEqualToString:@"all"]) {
                                                                  [[NSNotificationCenter defaultCenter] postNotificationName:PG_NOTIFICATION_CITY_GUIDE_REFRESH object:nil];
                                                              } else {
                                                                  [weakself.viewModel clearPagination];
                                                                  [weakself.viewModel requestArticles:weakself.cityId];
                                                              }
                                                          });
                                                      }];
        [_articlesCollectionView enableInfiniteScrolling:^{
            [weakself.viewModel requestArticles:weakself.cityId];
        }];
    }
    return _articlesCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
