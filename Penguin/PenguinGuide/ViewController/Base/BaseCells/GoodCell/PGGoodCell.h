//
//  PGGoodCell.h
//  Penguin
//
//  Created by Jing Dai on 9/1/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGGood.h"

@interface PGGoodCell : PGBaseCollectionViewCell

- (void)setCellWithGood:(PGGood *)good;
- (void)setGrayBackgroundCellWithGood:(PGGood *)good;

+ (CGSize)cellSize;

@end
