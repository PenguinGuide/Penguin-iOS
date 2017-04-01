//
//  PGExploreViewModel.h
//  Penguin
//
//  Created by Jing Dai on 8/29/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewModel.h"
#import "PGArticleBanner.h"
#import "PGTag.h"

@interface PGExploreViewModel : PGBaseViewModel

@property (nonatomic, strong, readonly) NSArray *hotArticlesArray;
@property (nonatomic, strong, readonly) PGArticleBanner *currentArticle;
@property (nonatomic, strong, readonly) NSArray *tagsArray;
@property (nonatomic, strong, readonly) NSArray *articlesArray;

- (void)requestArticles;
- (void)collectArticle:(NSString *)articleId completion:(void(^)(BOOL success))completion;
- (void)disCollectArticle:(NSString *)articleId completion:(void(^)(BOOL success))completion;

@end
