//
//  PGSearchResultsViewModel.m
//  Penguin
//
//  Created by Jing Dai on 8/29/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGSearchResultsViewModel.h"

@interface PGSearchResultsViewModel ()

@property (nonatomic, strong, readwrite) NSArray *articlesArray;
@property (nonatomic, strong, readwrite) NSArray *goodsArray;

@end

@implementation PGSearchResultsViewModel

- (void)searchArticles:(NSString *)keyword
{
    PGWeakSelf(self);
    
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Search_Articles;
        config.keyPath = @"data";
        config.model = [PGArticleBanner new];
        config.isMockAPI = YES;
        config.mockFileName = @"v1_search_articles.json";
    } completion:^(id response) {
        weakself.articlesArray = response;
    } failure:^(NSError *error) {
        
    }];
}

- (void)searchGoods:(NSString *)keyword
{
    PGWeakSelf(self);
    
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Search_Goods;
        config.keyPath = @"data";
        config.model = [PGGood new];
        config.isMockAPI = YES;
        config.mockFileName = @"v1_search_goods.json";
    } completion:^(id response) {
        weakself.goodsArray = response;
    } failure:^(NSError *error) {
        
    }];
}

@end
