//
//  PGArticleCommentCell.h
//  Penguin
//
//  Created by Jing Dai on 21/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGComment.h"

@class PGArticleCommentCell;

@protocol PGArticleCommentCellDelegate <NSObject>

- (void)commentMoreButtonClicked:(PGArticleCommentCell *)cell;

@end

@interface PGArticleCommentCell : UICollectionViewCell

@property (nonatomic, weak) id<PGArticleCommentCellDelegate> delegate;

- (void)setCellWithComment:(PGComment *)comment;
- (void)selectLabel;
- (void)unselectLabel;

+ (CGSize)cellSize:(PGComment *)comment;

@end
