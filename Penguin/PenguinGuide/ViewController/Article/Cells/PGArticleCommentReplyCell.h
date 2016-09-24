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

@end

@interface PGArticleCommentReplyCell : UICollectionViewCell

@property (nonatomic, weak) id<PGArticleCommentReplyCellDelegate> delegate;

- (void)setCellWithComment:(PGComment *)comment;
- (void)selectLabel;
- (void)unselectLabel;

+ (CGSize)cellSize:(PGComment *)comment;

@end
