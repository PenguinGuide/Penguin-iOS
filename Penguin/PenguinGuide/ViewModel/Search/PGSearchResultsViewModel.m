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

@property (nonatomic, strong, readwrite) NSArray *articlesNextPageIndexes;
@property (nonatomic, strong, readwrite) NSArray *goodsNextPageIndexes;

@property (nonatomic, assign, readwrite) BOOL isPreloadingArticlesNextPage;
@property (nonatomic, assign, readwrite) BOOL isPreloadingGoodsNextPage;
@property (nonatomic, assign, readwrite) BOOL articlesEndFlag;
@property (nonatomic, assign, readwrite) BOOL goodsEndFlag;

@end

@implementation PGSearchResultsViewModel

- (void)searchArticles:(NSString *)keyword
{
    if (self.isPreloadingArticlesNextPage || self.articlesEndFlag) {
        return;
    }
    
    self.isPreloadingArticlesNextPage = YES;
    
    if (!self.articlesResponse) {
        self.articlesResponse = [[PGRKResponse alloc] init];
        self.articlesResponse.pagination.needPerformingBatchUpdate = YES;
        self.articlesResponse.pagination.paginateSections = NO;
        self.articlesResponse.pagination.paginationKey = @"next";
    }
    
    PGParams *params = [PGParams new];
    params[@"type"] = @"article";
    params[@"keyword"] = keyword;
    params[@"per_page"] = @(10);
    
    PGWeakSelf(self);
    
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Search;
        config.params = params;
        config.keyPath = @"items";
        config.model = [PGArticleBanner new];
        config.response = weakself.articlesResponse;
    } paginationCompletion:^(PGRKResponse *response) {
        weakself.articlesResponse = response;
        weakself.articlesNextPageIndexes = response.pagination.nextPageIndexesArray;
        weakself.articles = response.dataArray;
        weakself.articlesEndFlag = response.pagination.endFlag;
        
        weakself.isPreloadingArticlesNextPage = NO;
    } failure:^(NSError *error) {
        weakself.error = error;
        
        weakself.isPreloadingArticlesNextPage = NO;
    }];
}

- (void)searchGoods:(NSString *)keyword
{
    if (self.isPreloadingGoodsNextPage || self.goodsEndFlag) {
        return;
    }
    
    self.isPreloadingGoodsNextPage = YES;
    
    if (!self.goodsResponse) {
        self.goodsResponse = [[PGRKResponse alloc] init];
        self.goodsResponse.pagination.needPerformingBatchUpdate = YES;
        self.goodsResponse.pagination.paginateSections = NO;
        self.goodsResponse.pagination.paginationKey = @"next";
    }
    
    PGParams *params = [PGParams new];
    params[@"type"] = @"product";
    params[@"keyword"] = keyword;
    params[@"per_page"] = @(10);
    
    PGWeakSelf(self);
    
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Search;
        config.params = params;
        config.keyPath = @"items";
        config.model = [PGGood new];
        config.response = weakself.goodsResponse;
    } paginationCompletion:^(PGRKResponse *response) {
        weakself.goodsResponse = response;
        weakself.goodsNextPageIndexes = response.pagination.nextPageIndexesArray;
        weakself.goods = response.dataArray;
        weakself.goodsEndFlag = response.pagination.endFlag;
        
        weakself.isPreloadingGoodsNextPage = NO;
    } failure:^(NSError *error) {
        weakself.error = error;
        
        weakself.isPreloadingGoodsNextPage = NO;
    }];
}

- (void)clearViewModel
{
    self.articlesNextPageIndexes = nil;
    self.goodsNextPageIndexes = nil;
    
    self.articlesResponse = nil;
    self.goodsResponse = nil;
    self.articles = nil;
    self.goods = nil;
    
    self.isPreloadingArticlesNextPage = NO;
    self.isPreloadingGoodsNextPage = NO;
    self.articlesEndFlag = NO;
    self.goodsEndFlag = NO;
}

@end
