//
//  PGSingleGoodBannerCell.h
//  Penguin
//
//  Created by Jing Dai on 8/24/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGSingleGoodBanner.h"

@interface PGSingleGoodBannerCell : PGBaseCollectionViewCell

- (void)setCellWithSingleGood:(PGSingleGoodBanner *)singleGood;

+ (CGSize)cellSize;

@end
