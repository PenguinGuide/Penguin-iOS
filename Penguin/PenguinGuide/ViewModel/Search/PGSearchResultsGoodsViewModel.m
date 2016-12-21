//
//  PGSearchResultsGoodsViewModel.m
//  Penguin
//
//  Created by Kobe Dai on 15/12/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGSearchResultsGoodsViewModel.h"

@interface PGSearchResultsGoodsViewModel ()

@property (nonatomic, strong, readwrite) NSArray *goodsArray;

@end

@implementation PGSearchResultsGoodsViewModel

- (void)requestGoods:(NSString *)keyword
{
    if (self.isPreloadingNextPage || self.endFlag) {
        return;
    }
    
    self.isPreloadingNextPage = YES;
    
    if (!self.response) {
        self.response = [[PGRKResponse alloc] init];
        self.response.pagination.needPerformingBatchUpdate = NO;
        self.response.pagination.paginateSections = NO;
        self.response.pagination.paginationKey = @"next";
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
        config.response = weakself.response;
    } paginationCompletion:^(PGRKResponse *response) {
        weakself.response = response;
        weakself.goodsArray = response.dataArray;
        weakself.endFlag = response.pagination.endFlag;
        
        weakself.isPreloadingNextPage = NO;
    } failure:^(NSError *error) {
        weakself.error = error;
        
        weakself.isPreloadingNextPage = NO;
    }];
}

- (void)clearPagination
{
    self.response = nil;
    self.endFlag = NO;
    self.isPreloadingNextPage = NO;
}

@end
