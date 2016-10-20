//
//  PGFlashbuyBannerCell.h
//  Penguin
//
//  Created by Jing Dai on 8/24/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGFlashbuyBanner.h"
#import "PGPagedScrollView.h"

@interface PGFlashbuyBannerCell : UICollectionViewCell

@property (nonatomic, strong, readonly) PGPagedScrollView *bannersView;

- (void)reloadBannersWithFlashbuy:(PGFlashbuyBanner *)flashbuy;
- (void)countdown:(PGFlashbuyBanner *)flashbuy;

+ (CGSize)cellSize;

@end
