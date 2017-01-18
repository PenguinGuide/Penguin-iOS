//
//  PGScenarioGoodsViewController.m
//  Penguin
//
//  Created by Jing Dai on 02/12/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define GoodCell @"GoodCell"

#import "PGScenarioGoodsViewController.h"
#import "PGScenarioGoodsViewModel.h"
#import "PGScenarioGoodsCollectionView.h"
#import "PGGoodCell.h"

@interface PGScenarioGoodsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSString *scenarioId;

@property (nonatomic, strong) PGScenarioGoodsCollectionView *goodsCollectionView;
@property (nonatomic, strong) PGScenarioGoodsViewModel *viewModel;

@end

@implementation PGScenarioGoodsViewController

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
    
    [self.view addSubview:self.goodsCollectionView];
    
    self.viewModel = [[PGScenarioGoodsViewModel alloc] initWithAPIClient:self.apiClient];
    
    PGWeakSelf(self);
    
    [self observe:self.viewModel keyPath:@"goodsArray" block:^(id changedObject) {
        NSArray *goodsArray = changedObject;
        if (goodsArray && [goodsArray isKindOfClass:[NSArray class]]) {
            [UIView setAnimationsEnabled:NO];
            [weakself.goodsCollectionView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView setAnimationsEnabled:YES];
            });
        }
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(dismissPageLoading)]) {
            [weakself.delegate dismissPageLoading];
        }
        [weakself.goodsCollectionView endBottomRefreshing];
    }];
    [self observeError:self.viewModel];
    [self observeCollectionView:self.goodsCollectionView endOfFeeds:self.viewModel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadView];
}

- (void)reloadView
{
    if (self.viewModel.goodsArray.count == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(showPageLoading)]) {
            [self.delegate showPageLoading];
        }
        [self.viewModel requestGoods:self.scenarioId];
    }
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
    PGGoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodCell forIndexPath:indexPath];
    
    [cell setCellWithGood:self.viewModel.goodsArray[indexPath.item]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [PGGoodCell cellSize];
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
    return 10.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 11.f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 8, 10, 8);
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
    PGGood *good = self.viewModel.goodsArray[indexPath.item];
    [PGRouterManager routeToGoodDetailPage:good.goodId link:good.link];
}

#pragma mark - <Lazy Init>

- (PGBaseCollectionView *)goodsCollectionView
{
    if (!_goodsCollectionView) {
        _goodsCollectionView = [[PGScenarioGoodsCollectionView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT-64-50) collectionViewLayout:[UICollectionViewFlowLayout new]];
        _goodsCollectionView.dataSource = self;
        _goodsCollectionView.delegate = self;
        _goodsCollectionView.showsHorizontalScrollIndicator = NO;
        _goodsCollectionView.showsVerticalScrollIndicator = NO;
        
        [_goodsCollectionView registerClass:[PGGoodCell class] forCellWithReuseIdentifier:GoodCell];
        
        PGWeakSelf(self);
        [_goodsCollectionView enableInfiniteScrolling:^{
            [weakself.viewModel requestGoods:weakself.scenarioId];
        }];
    }
    return _goodsCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
