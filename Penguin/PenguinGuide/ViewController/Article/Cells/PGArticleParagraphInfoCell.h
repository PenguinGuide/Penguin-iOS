//
//  PGArticleParagraphInfoCell.h
//  Penguin
//
//  Created by Jing Dai on 9/19/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGArticle.h"

@interface PGArticleParagraphInfoCell : UICollectionViewCell

- (void)setCellWithArticle:(PGArticle *)article;
+ (CGSize)cellSize:(PGArticle *)article;

@end
