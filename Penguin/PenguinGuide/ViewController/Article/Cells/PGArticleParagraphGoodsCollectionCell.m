//
//  PGArticleParagraphGoodsCollectionCell.m
//  Penguin
//
//  Created by Jing Dai on 28/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define GoodCell @"GoodCell"

#import "PGArticleParagraphGoodsCollectionCell.h"
#import "PGGoodsCollectionGoodCell.h"

@interface PGArticleParagraphGoodsCollectionCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *goodsArray;
@property (nonatomic, strong) UIView *goodsView;
@property (nonatomic, strong) PGBaseCollectionView *goodsCollectionView;
@property (nonatomic, strong) UIImageView *pinImageView;

@end

@implementation PGArticleParagraphGoodsCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    [self.contentView addSubview:self.goodsCollectionView];
    [self.contentView addSubview:self.pinImageView];
}

- (void)reloadCellWithGoodsArray:(NSArray *)goodsArray
{
    self.goodsArray = goodsArray;
    
    [self.goodsCollectionView reloadData];
}

#pragma mark - <UICollectionViewDataSource>

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
    PGGoodsCollectionGoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodCell forIndexPath:indexPath];
    
    PGGood *good = self.goodsArray[indexPath.item];
    [cell setCellWithGood:good];
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(160, 220);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGGood *good = self.goodsArray[indexPath.item];
    [[PGRouter sharedInstance] openURL:good.link];
}

#pragma mark - <Setters && Getters>

- (PGBaseCollectionView *)goodsCollectionView
{
    if (!_goodsCollectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0.f;
        layout.minimumLineSpacing = 10.f;
        _goodsCollectionView = [[PGBaseCollectionView alloc] initWithFrame:CGRectMake(0, 15, self.pg_width, self.pg_height-30) collectionViewLayout:layout];
        _goodsCollectionView.dataSource = self;
        _goodsCollectionView.delegate = self;
        _goodsCollectionView.showsVerticalScrollIndicator = NO;
        _goodsCollectionView.showsHorizontalScrollIndicator = NO;
        _goodsCollectionView.alwaysBounceVertical = NO;
        _goodsCollectionView.backgroundColor = [UIColor whiteColor];
        _goodsCollectionView.layer.borderWidth = 2.f;
        _goodsCollectionView.layer.borderColor = Theme.colorText.CGColor;
        _goodsCollectionView.backgroundColor = [UIColor whiteColor];
        
        [_goodsCollectionView registerClass:[PGGoodsCollectionGoodCell class] forCellWithReuseIdentifier:GoodCell];
    }
    return _goodsCollectionView;
}

- (UIImageView *)pinImageView
{
    if (!_pinImageView) {
        _pinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 16, 44)];
        _pinImageView.image = [UIImage imageNamed:@"pg_article_goods_collection_pin"];
    }
    return _pinImageView;
}

@end
