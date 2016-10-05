//
//  PGGoodBannersCell.h
//  Penguin
//
//  Created by Jing Dai on 29/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGGoodBannersCell : UICollectionViewCell

- (void)reloadCellWithBanners:(NSArray *)banners;

+ (CGSize)cellSize;

@end
