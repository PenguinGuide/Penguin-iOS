//
//  PGGoodBannersCell.h
//  Penguin
//
//  Created by Jing Dai on 29/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGPagedScrollView.h"

@interface PGGoodBannersCell : PGBaseCollectionViewCell

@property (nonatomic, strong, readonly) PGPagedScrollView *pagedScrollView;

- (void)reloadCellWithBanners:(NSArray *)banners;

+ (CGSize)cellSize;

@end
