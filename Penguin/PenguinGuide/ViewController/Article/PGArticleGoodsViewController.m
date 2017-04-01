//
//  PGArticleGoodsViewController.m
//  Penguin
//
//  Created by Kobe Dai on 27/03/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#define GoodCell @"GoodCell"

#import "PGArticleGoodsViewController.h"
#import "PGSingleGoodBannerCell.h"

@interface PGArticleGoodsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *goodsArray;
@property (nonatomic, strong) PGBaseCollectionView *goodsCollectionView;

@end

@implementation PGArticleGoodsViewController

- (id)initWithGoods:(NSArray *)goodsArray
{
    if (self = [super init]) {
        self.goodsArray = goodsArray;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationTitle:@"文章商品"];
    
    [self.view addSubview:self.goodsCollectionView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (BOOL)shouldHideNavigationBar
{
    return NO;
}

#pragma mark - <UICollectionView>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.goodsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGSingleGoodBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodCell forIndexPath:indexPath];
    
    if ([cell respondsToSelector:@selector(setCellWithModel:)]) {
        [cell setCellWithModel:self.goodsArray[indexPath.item]];
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionFooter) {
        PGBaseCollectionViewFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BaseCollectionViewFooterView forIndexPath:indexPath];
        return footerView;
    }
    return nil;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [PGSingleGoodBannerCell cellSize];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return [PGBaseCollectionViewFooterView footerViewSize];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *selectedCell = [collectionView cellForItemAtIndexPath:indexPath];
    if ([selectedCell respondsToSelector:@selector(cellDidSelectWithModel:)]) {
        [(id<PGBaseCollectionViewCell>)selectedCell cellDidSelectWithModel:self.goodsArray[indexPath.item]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[PGBaseCollectionViewCell class]]) {
        [(PGBaseCollectionViewCell *)cell insertCellBorderLayer:8.f];
    }
}

#pragma mark - <Lazy Init>

- (PGBaseCollectionView *)goodsCollectionView
{
    if (!_goodsCollectionView) {
        _goodsCollectionView = [[PGBaseCollectionView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT) collectionViewLayout:[UICollectionViewFlowLayout new]];
        _goodsCollectionView.dataSource = self;
        _goodsCollectionView.delegate = self;
        
        [_goodsCollectionView registerClass:[PGSingleGoodBannerCell class] forCellWithReuseIdentifier:GoodCell];
    }
    return _goodsCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
