//
//  PGCategoryCell.h
//  Penguin
//
//  Created by Jing Dai on 23/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGCategoryIcon.h"

@interface PGCategoryCell : UICollectionViewCell

- (void)setCellWithCategoryIcon:(PGCategoryIcon *)icon;

+ (CGSize)cellSize;

@end
