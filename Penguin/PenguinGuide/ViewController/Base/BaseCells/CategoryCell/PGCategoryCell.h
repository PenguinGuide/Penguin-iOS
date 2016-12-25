//
//  PGCategoryCell.h
//  Penguin
//
//  Created by Jing Dai on 23/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGScenarioBanner.h"

@interface PGCategoryCell : UICollectionViewCell

- (void)setCellWithCategoryIcon:(PGScenarioBanner *)icon;

+ (CGSize)cellSize;

@end
