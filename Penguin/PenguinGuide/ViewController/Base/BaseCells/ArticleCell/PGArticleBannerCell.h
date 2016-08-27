//
//  PGArticleBannerCell.h
//  Penguin
//
//  Created by Jing Dai on 7/12/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGArticleBanner.h"
#import "FLAnimatedImage.h"

@interface PGArticleBannerCell : UICollectionViewCell

@property (nonatomic, strong, readonly) FLAnimatedImageView *bannerImageView;

- (void)setCellWithArticle:(PGArticleBanner *)article;

+ (CGSize)cellSize;

@end