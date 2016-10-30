//
//  PGArticleCommentReplyCell.h
//  Penguin
//
//  Created by Jing Dai on 21/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGComment.h"

@class PGArticleCommentReplyCell;

@protocol PGArticleCommentReplyCellDelegate <NSObject>

- (void)commentReplyMoreButtonClicked:(PGArticleCommentReplyCell *)cell;
- (void)commentReplyLikeButtonClicked:(PGArticleCommentReplyCell *)cell;
- (void)commentReplyDislikeButtonClicked:(PGArticleCommentReplyCell *)cell;

@end

@interface PGArticleCommentReplyCell : UICollectionViewCell

@property (nonatomic, weak) id<PGArticleCommentReplyCellDelegate> delegate;

- (void)setCellWithComment:(PGComment *)comment;
- (void)selectLabel;
- (void)unselectLabel;
- (void)animateLikeButton:(NSInteger)count;
- (void)animateDislikeButton:(NSInteger)count;

+ (CGSize)cellSize:(PGComment *)comment;

@end
