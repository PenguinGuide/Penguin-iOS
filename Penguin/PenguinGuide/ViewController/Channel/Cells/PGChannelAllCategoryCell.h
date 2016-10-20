//
//  PGChannelAllCategoryCell.h
//  Penguin
//
//  Created by Jing Dai on 8/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGChannelCategory.h"

@interface PGChannelAllCategoryCell : UICollectionViewCell

- (void)setCellWithCategory:(PGChannelCategory *)category;

+ (CGSize)cellSize;

@end
