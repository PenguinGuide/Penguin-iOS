//
//  PGSearchResultsGoodsViewController.m
//  Penguin
//
//  Created by Kobe Dai on 15/12/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define GoodCell @"GoodCell"

#import "PGSearchResultsGoodsViewController.h"
#import "PGGoodViewController.h"

#import "PGSearchResultsGoodsViewModel.h"

#import "PGSingleGoodBannerCell.h"

@interface PGSearchResultsGoodsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSString *keyword;

@property (nonatomic, strong) PGBaseCollectionView *goodsCollectionView;

@property (nonatomic, strong) PGSearchResultsGoodsViewModel *viewModel;

@end

@implementation PGSearchResultsGoodsViewController

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
    
    [self.view addSubview:self.goodsCollectionView];
    
    self.viewModel = [[PGSearchResultsGoodsViewModel alloc] initWithAPIClient:self.apiClient];
    
    PGWeakSelf(self);
    
    [self observe:self.viewModel keyPath:@"goodsArray" block:^(id changedObject) {
        NSArray *articlesArray = changedObject;
        if (articlesArray && [articlesArray isKindOfClass:[NSArray class]]) {
            [UIView setAnimationsEnabled:NO];
            [weakself.goodsCollectionView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView setAnimationsEnabled:YES];
            });
        }
        [weakself dismissLoading];
        [weakself.goodsCollectionView endBottomRefreshing];
    }];
    [self observeCollectionView:self.goodsCollectionView endOfFeeds:self.viewModel];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self reloadView];
}

- (void)dealloc
{
    if (self.isViewLoaded) {
        [self unobserve];
    }
}

- (void)reloadView
{
    if (self.viewModel.goodsArray.count == 0) {
        [self showLoading];
        [self.viewModel requestGoods:self.keyword];
    }
}

- (void)reloadWithKeyword:(NSString *)keyword
{
    [self.viewModel clearPagination];
    self.keyword = keyword;
    [self.viewModel requestGoods:self.keyword];
}

#pragma mark - <UICollectionView>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.goodsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.viewModel.goodsArray.count-indexPath.item == 2) {
        PGWeakSelf(self);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [weakself.viewModel requestGoods:self.keyword];
        });
    }
    PGSingleGoodBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodCell forIndexPath:indexPath];
    
    PGSingleGoodBanner *good = self.viewModel.goodsArray[indexPath.item];
    cell.eventName = good_banner_clicked;
    cell.eventId = good.goodsId;
    cell.pageName = search_results_view;
    
    [cell setCellWithSingleGood:good];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [PGSingleGoodBannerCell cellSize];
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

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.f;
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
    PGGood *good = self.viewModel.goodsArray[indexPath.item];
    [PGRouterManager routeToGoodDetailPage:good.goodId link:good.link];
}

- (PGBaseCollectionView *)goodsCollectionView
{
    if (!_goodsCollectionView) {
        _goodsCollectionView = [[PGBaseCollectionView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT-60-60) collectionViewLayout:[UICollectionViewFlowLayout new]];
        _goodsCollectionView.backgroundColor = [UIColor whiteColor];
        _goodsCollectionView.dataSource = self;
        _goodsCollectionView.delegate = self;
        
        [_goodsCollectionView registerClass:[PGSingleGoodBannerCell class] forCellWithReuseIdentifier:GoodCell];
        
        PGWeakSelf(self);
        [_goodsCollectionView enableInfiniteScrolling:^{
            [weakself.viewModel requestGoods:weakself.keyword];
        }];
    }
    return _goodsCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
