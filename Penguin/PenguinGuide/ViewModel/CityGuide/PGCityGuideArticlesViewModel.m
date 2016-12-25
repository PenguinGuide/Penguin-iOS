//
//  PGCityGuideArticlesViewModel.m
//  Penguin
//
//  Created by Jing Dai on 28/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGCityGuideArticlesViewModel.h"
#import "PGArticleBanner.h"

@interface PGCityGuideArticlesViewModel ()

@property (nonatomic, strong, readwrite) NSArray *articlesArray;
@property (nonatomic, strong, readwrite) NSArray *nextPageIndexes;

@end

@implementation PGCityGuideArticlesViewModel

- (void)requestArticles:(NSString *)cityId
{
    if (self.isPreloadingNextPage || self.endFlag) {
        return;
    }
    
    if (cityId && cityId.length > 0) {
        self.isPreloadingNextPage = YES;
        
        if (!self.response) {
            self.response = [[PGRKResponse alloc] init];
            self.response.pagination.needPerformingBatchUpdate = YES;
            self.response.pagination.paginationKey = @"cursor";
            self.response.pagination.paginateSections = NO;
        }
        
        PGParams *params = [PGParams new];
        params[ParamsPerPage] = @10;
        params[ParamsPageCursor] = self.response.pagination.cursor;
        if (![cityId isEqualToString:@"all"]) {
            params[@"city_id"] = cityId;
        }
        
        PGWeakSelf(self);
        
        [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
            config.route = PG_City_Guide_City_Articles;
            config.keyPath = @"items";
            config.model = [PGArticleBanner new];
            config.params = params;
            config.response = weakself.response;
        } paginationCompletion:^(PGRKResponse *response) {
            weakself.response = response;
            weakself.nextPageIndexes = response.pagination.nextPageIndexesArray;
            weakself.articlesArray = response.dataArray;
            weakself.endFlag = response.pagination.endFlag;
            
            weakself.isPreloadingNextPage = NO;
        } failure:^(NSError *error) {
            weakself.error = error;
            
            weakself.isPreloadingNextPage = NO;
        }];
    }
}

- (void)clearPagination
{
    self.response = nil;
    self.endFlag = NO;
    self.isPreloadingNextPage = NO;
    self.nextPageIndexes = nil;
}

@end
