//
//  PGSearchResultsViewModel.m
//  Penguin
//
//  Created by Jing Dai on 8/29/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGSearchResultsViewModel.h"

@interface PGSearchResultsViewModel ()

@property (nonatomic, strong, readwrite) NSArray *articles;
@property (nonatomic, strong, readwrite) NSArray *goods;

@property (nonatomic, assign, readwrite) NSInteger articlesPage;
@property (nonatomic, assign, readwrite) NSInteger goodsPage;

@end

@implementation PGSearchResultsViewModel

- (void)searchArticles:(NSString *)keyword
{
    self.articlesPage = 1;
    
    PGParams *params = [PGParams new];
    params[@"type"] = @"article";
    params[@"keyword"] = keyword;
    params[@"page"] = @(self.articlesPage);
    
    PGWeakSelf(self);
    
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Search;
        config.params = params;
        config.keyPath = @"items";
        config.model = [PGArticleBanner new];
    } completion:^(id response) {
        weakself.articles = response;
        if ([response count] > 0) {
            weakself.articlesPage++;
        }
    } failure:^(NSError *error) {
        weakself.error = error;
    }];
}

- (void)searchGoods:(NSString *)keyword
{
    PGParams *params = [PGParams new];
    params[@"type"] = @"product";
    params[@"keyword"] = keyword;
    
    PGWeakSelf(self);
    
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Search;
        config.params = params;
        config.keyPath = @"items";
        config.model = [PGGood new];
    } completion:^(id response) {
        weakself.goods = response;
    } failure:^(NSError *error) {
        weakself.error = error;
    }];
}

- (void)loadArticlesNextPage:(NSString *)keyword
{
    PGParams *params = [PGParams new];
    params[@"type"] = @"article";
    params[@"keyword"] = keyword;
    params[@"page"] = @(self.articlesPage);
    
    PGWeakSelf(self);
    
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Search;
        config.params = params;
        config.keyPath = @"items";
        config.model = [PGArticleBanner new];
    } completion:^(id response) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)loadGoodsNextPage:(NSString *)keyword
{
    
}

@end
