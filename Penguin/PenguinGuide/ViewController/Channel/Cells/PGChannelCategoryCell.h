//
//  PGChannelCategoryCell.h
//  Penguin
//
//  Created by Jing Dai on 8/26/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGChannelCategory.h"

@interface PGChannelCategoryCell : UICollectionViewCell

- (void)setCellWithCategory:(PGChannelCategory *)category;
- (void)setMoreCategoryCell;

@end
