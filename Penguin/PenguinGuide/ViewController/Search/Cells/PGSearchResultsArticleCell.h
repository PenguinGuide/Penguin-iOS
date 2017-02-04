//
//  PGSearchResultsArticleCell.h
//  Penguin
//
//  Created by Jing Dai on 8/29/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGArticleBanner.h"

@interface PGSearchResultsArticleCell : PGBaseCollectionViewCell

- (void)setCellWithArticle:(PGArticleBanner *)article;

+ (CGSize)cellSize;

@end
