//
//  PGSearchResultsViewModel.h
//  Penguin
//
//  Created by Jing Dai on 8/29/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewModel.h"
#import "PGArticleBanner.h"
#import "PGGood.h"

@interface PGSearchResultsViewModel : PGBaseViewModel

@property (nonatomic, strong, readonly) NSArray *articles;
@property (nonatomic, strong, readonly) NSArray *goods;

@property (nonatomic, strong, readwrite) PGRKResponse *articlesResponse;
@property (nonatomic, strong, readwrite) PGRKResponse *goodsResponse;

@property (nonatomic, strong, readonly) NSArray *articlesNextPageIndexes;
@property (nonatomic, strong, readonly) NSArray *goodsNextPageIndexes;

@property (nonatomic, assign, readonly) BOOL articlesEndFlag;
@property (nonatomic, assign, readonly) BOOL goodsEndFlag;

- (void)searchArticles:(NSString *)keyword;
- (void)searchGoods:(NSString *)keyword;

- (void)clearViewModel;

@end
