//
//  PGBaseCollectionViewCell.h
//  Penguin
//
//  Created by Kobe Dai on 04/02/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PGBaseCollectionViewCell;

@protocol PGBaseCollectionViewCell <NSObject>

@optional

- (void)setCellWithModel:(PGRKModel *)model;
- (void)cellDidSelectWithModel:(PGRKModel *)model;
- (void)moreCellDidSelectWithLink:(NSString *)link;

@end

@interface PGBaseCollectionViewCell : UICollectionViewCell <PGBaseCollectionViewCell>

+ (CGSize)cellSize;

- (void)insertCellBorderLayer:(CGFloat)cornerRadius;
- (void)insertCellBorderLayer:(CGFloat)cornerRadius rect:(CGRect)rect;
- (void)insertCellMask:(CGFloat)cornerRadius;

@end
