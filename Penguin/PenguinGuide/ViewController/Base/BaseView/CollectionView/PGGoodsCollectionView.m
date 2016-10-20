//
//  PGGoodsCollectionView.m
//  Penguin
//
//  Created by Jing Dai on 9/1/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define GoodCell @"GoodCell"

#import "PGGoodsCollectionView.h"

@interface PGGoodsCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation PGGoodsCollectionView

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = Theme.colorBackground;
        
        [self registerClass:[PGGoodCell class] forCellWithReuseIdentifier:GoodCell];
    }
    
    return self;
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.goodsDelegate && [self.goodsDelegate respondsToSelector:@selector(goodsArray)]) {
        return [self.goodsDelegate goodsArray].count;
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGGoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodCell forIndexPath:indexPath];
    
    NSArray *goodsArray = [self.goodsDelegate goodsArray];
    [cell setCellWithGood:goodsArray[indexPath.item]];
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [PGGoodCell cellSize];
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
    if (self.goodsDelegate && [self.goodsDelegate respondsToSelector:@selector(topEdgeInsets)]) {
        if (section == 0) {
            return [self.goodsDelegate topEdgeInsets];
        }
    }
    return UIEdgeInsetsMake(10, 8, 10, 8);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.goodsDelegate && [self.goodsDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.goodsDelegate scrollViewDidScroll:scrollView];
    }
}

@end
