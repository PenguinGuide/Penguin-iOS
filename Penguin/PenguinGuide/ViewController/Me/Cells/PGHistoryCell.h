//
//  PGHistoryCell.h
//  Penguin
//
//  Created by Jing Dai on 31/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGHistory.h"

@interface PGHistoryCell : UICollectionViewCell

- (void)setCellWithHistory:(PGHistory *)history;
+ (CGSize)cellSize:(PGHistory *)history;

@end
