//
//  PGArticleParagraphInfoCell.h
//  Penguin
//
//  Created by Jing Dai on 9/19/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGArticle.h"

@protocol PGArticleParagraphInfoCellDelegate <NSObject>

- (void)tagDidSelect:(PGTag *)tag;

@end

@interface PGArticleParagraphInfoCell : UICollectionViewCell

@property (nonatomic, weak) id<PGArticleParagraphInfoCellDelegate> delegate;

- (void)setCellWithArticle:(PGArticle *)article;
+ (CGSize)cellSize:(PGArticle *)article;

@end
