//
//  PGSearchResultsArticlesViewModel.h
//  Penguin
//
//  Created by Kobe Dai on 15/12/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewModel.h"
#import "PGArticleBanner.h"

@interface PGSearchResultsArticlesViewModel : PGBaseViewModel

@property (nonatomic, strong, readonly) NSArray *articlesArray;

- (void)requestArticles:(NSString *)keyword;
- (void)collectArticle:(NSString *)articleId completion:(void(^)(BOOL success))completion;
- (void)disCollectArticle:(NSString *)articleId completion:(void(^)(BOOL success))completion;

@end
