//
//  PGArticleRelatedArticlesCell.h
//  Penguin
//
//  Created by Jing Dai on 9/20/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGPagedScrollView.h"

@interface PGArticleRelatedArticlesCell : UICollectionViewCell

- (void)setCellWithDataArray:(NSArray *)dataArray;
+ (CGSize)cellSize;

@end
