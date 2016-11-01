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

- (void)searchArticles:(NSString *)keyword;
- (void)searchGoods:(NSString *)keyword;

@end
