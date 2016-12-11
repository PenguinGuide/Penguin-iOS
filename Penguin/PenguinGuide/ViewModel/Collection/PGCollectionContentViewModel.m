//
//  PGCollectionContentViewModel.m
//  Penguin
//
//  Created by Jing Dai on 30/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGCollectionContentViewModel.h"

@interface PGCollectionContentViewModel ()

@property (nonatomic, strong, readwrite) NSArray *articles;

@end

@implementation PGCollectionContentViewModel

- (void)requestData
{
    if (self.isPreloadingNextPage || self.endFlag) {
        return;
    }
    
    self.isPreloadingNextPage = YES;
    
    if (!self.response) {
        self.response = [[PGRKResponse alloc] init];
        self.response.pagination.needPerformingBatchUpdate = NO;
        self.response.pagination.paginationKey = @"cursor";
    }
    
    PGParams *params = [PGParams new];
    params[ParamsPerPage] = @10;
    params[ParamsPageCursor] = self.response.pagination.cursor;
    
    PGWeakSelf(self);
    
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Collection_Articles;
        config.keyPath = @"items";
        config.params = params;
        config.model = [PGArticleBanner new];
        config.response = weakself.response;
    } paginationCompletion:^(PGRKResponse *response) {
        weakself.articles = response.dataArray;
        weakself.response = response;
        weakself.endFlag = weakself.response.pagination.endFlag;
        
        weakself.isPreloadingNextPage = NO;
    } failure:^(NSError *error) {
        weakself.error = error;
        
        weakself.isPreloadingNextPage = NO;
    }];
}

@end
