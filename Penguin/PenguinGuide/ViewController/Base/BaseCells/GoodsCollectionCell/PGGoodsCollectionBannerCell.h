//
//  PGGoodsCollectionBannerCell.h
//  Penguin
//
//  Created by Jing Dai on 8/24/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGGoodsCollectionBanner.h"

@interface PGGoodsCollectionBannerCell : PGBaseCollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;

- (void)setCellWithGoodsCollection:(PGGoodsCollectionBanner *)goodsCollection;

+ (CGSize)cellSize;

@end
