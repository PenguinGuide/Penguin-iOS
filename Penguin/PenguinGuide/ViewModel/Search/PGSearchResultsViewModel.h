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

@property (nonatomic, strong, readonly) NSArray *articlesArray;
@property (nonatomic, strong, readonly) NSArray *goodsArray;

- (void)searchArticles:(NSString *)keyword;
- (void)searchGoods:(NSString *)keyword;

@end
