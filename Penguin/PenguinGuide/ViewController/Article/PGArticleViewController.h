//
//  PGArticleViewController.h
//  Penguin
//
//  Created by Jing Dai on 7/15/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewController.h"

@class PGArticle;

@interface PGArticleViewController : PGBaseViewController

@property (nonatomic, strong, readonly) PGBaseCollectionView *articleCollectionView;
@property (nonatomic, strong) UIImageView *headerImageView;

- (id)initWithArticleId:(NSString *)articleId animated:(BOOL)animated;
- (void)animateCollectionView:(void(^)())completion;

@end
