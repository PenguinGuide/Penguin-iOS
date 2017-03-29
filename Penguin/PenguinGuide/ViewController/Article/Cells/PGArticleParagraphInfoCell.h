//
//  PGArticleParagraphInfoCell.h
//  Penguin
//
//  Created by Jing Dai on 9/19/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGArticle.h"
#import "PGArticleInfo.h"

@protocol PGArticleParagraphInfoCellDelegate <NSObject>

- (void)tagDidSelect:(PGTag *)tag;

@end

@interface PGArticleParagraphInfoCell : PGBaseCollectionViewCell

@property (nonatomic, weak) id<PGArticleParagraphInfoCellDelegate> delegate;

- (void)setCellWithArticle:(PGArticle *)article tagsArray:(NSArray *)tagsArray;
+ (CGSize)cellSize:(PGArticle *)article tagsArray:(NSArray *)tagsArray;

@end
