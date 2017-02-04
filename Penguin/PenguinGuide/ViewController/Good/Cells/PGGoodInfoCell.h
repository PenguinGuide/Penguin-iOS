//
//  PGGoodNameCell.h
//  Penguin
//
//  Created by Jing Dai on 28/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGGood.h"

@interface PGGoodInfoCell : PGBaseCollectionViewCell

- (void)setCellWithGood:(PGGood *)good;

+ (CGSize)cellSize:(PGGood *)good;

@end
