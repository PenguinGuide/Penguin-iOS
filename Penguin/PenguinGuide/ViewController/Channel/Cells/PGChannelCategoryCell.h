//
//  PGChannelCategoryCell.h
//  Penguin
//
//  Created by Jing Dai on 8/26/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGChannelCategory.h"
#import "PGScenarioCategory.h"

@interface PGChannelCategoryCell : UICollectionViewCell

- (void)setCellWithChannelCategory:(PGChannelCategory *)category;
- (void)setCellWithScenarioCategory:(PGScenarioCategory *)category;
- (void)setMoreCategoryCell;

@end
