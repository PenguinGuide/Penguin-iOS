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
- (void)commentLikeButtonClicked:(PGArticleCommentCell *)cell;
- (void)commentDislikeButtonClicked:(PGArticleCommentCell *)cell;

@end

@interface PGArticleCommentCell : UICollectionViewCell

@property (nonatomic, weak) id<PGArticleCommentCellDelegate> delegate;

- (void)setCellWithComment:(PGComment *)comment;
- (void)selectLabel;
- (void)unselectLabel;
- (void)animateLikeButton:(NSInteger)count;
- (void)animateDislikeButton:(NSInteger)count;

+ (CGSize)cellSize:(PGComment *)comment;

@end
