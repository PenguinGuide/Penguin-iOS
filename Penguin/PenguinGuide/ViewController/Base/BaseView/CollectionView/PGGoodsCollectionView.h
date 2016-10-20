//
//  PGGoodsCollectionView.h
//  Penguin
//
//  Created by Jing Dai on 9/1/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseCollectionView.h"

#import "PGGood.h"

#import "PGGoodCell.h"

@protocol PGGoodsCollectionViewDelegate <NSObject>

- (NSArray *)goodsArray;

@optional

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (UIEdgeInsets)topEdgeInsets;

@end

@interface PGGoodsCollectionView : PGBaseCollectionView

@property (nonatomic, weak) id<PGGoodsCollectionViewDelegate> goodsDelegate;

@end
