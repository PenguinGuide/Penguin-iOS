//
//  PGScenarioViewModel.m
//  Penguin
//
//  Created by Jing Dai on 8/31/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGScenarioViewModel.h"

#import "PGCarouselBanner.h"
#import "PGArticleBanner.h"
#import "PGFlashbuyBanner.h"
#import "PGGoodsCollectionBanner.h"
#import "PGTopicBanner.h"
#import "PGSingleGoodBanner.h"
#import "PGImageBanner.h"
#import "PGGood.h"

@interface PGScenarioViewModel ()

@property (nonatomic, strong, readwrite) PGScenario *scenario;
@property (nonatomic, strong, readwrite) NSArray *feedsArray;
@property (nonatomic, strong, readwrite) NSArray *goodsArray;

@property (nonatomic, strong, readwrite) PGRKResponse *feedsResponse;
@property (nonatomic, strong, readwrite) PGRKResponse *goodsResponse;
@property (nonatomic, assign, readwrite) BOOL isPreloadingFeedsNextPage;
@property (nonatomic, assign, readwrite) BOOL isPreloadingGoodsNextPage;
@property (nonatomic, assign, readwrite) BOOL feedsEndFlag;
@property (nonatomic, assign, readwrite) BOOL goodsEndFlag;

@property (nonatomic, strong, readwrite) NSString *scenarioId;

@end

@implementation PGScenarioViewModel

- (void)requestScenario:(NSString *)scenarioId
{
    self.scenarioId = scenarioId;
    if (self.scenarioId && self.scenarioId.length > 0) {
        PGWeakSelf(self);
        [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
            config.route = PG_Scenario;
            config.pattern = @{@"scenarioId":weakself.scenarioId};
            config.keyPath = nil;
            config.model = [PGScenario new];
        } completion:^(id response) {
            weakself.scenario = [response firstObject];
            if (weakself.scenario) {
                [weakself requestFeeds];
            }
        } failure:^(NSError *error) {
            weakself.error = error;
        }];
    }
}

- (void)requestFeeds
{
    if (self.isPreloadingFeedsNextPage || self.feedsEndFlag) {
        return;
    }
    
    if (self.scenarioId && self.scenarioId.length > 0) {
        self.isPreloadingFeedsNextPage = YES;
        
        if (!self.feedsResponse) {
            self.feedsResponse = [[PGRKResponse alloc] init];
            self.feedsResponse.pagination.needPerformingBatchUpdate = NO;
            self.feedsResponse.pagination.paginationKey = @"cursor";
        }
        
        PGWeakSelf(self);
        
        PGParams *params = [PGParams new];
        params[ParamsPerPage] = @10;
        params[ParamsPageCursor] = self.feedsResponse.pagination.cursor;
        
        [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
            config.route = PG_Scenario_Feeds;
            config.keyPath = @"items";
            config.params = params;
            config.pattern = @{@"scenarioId":weakself.scenarioId};
            config.typeKey = @"type";
            config.response = weakself.feedsResponse;
            config.models = @[@{@"type":@"carousel", @"class":[PGCarouselBanner new]},
                              @{@"type":@"article", @"class":[PGArticleBanner new]},
                              @{@"type":@"flashbuy", @"class":[PGFlashbuyBanner new]},
                              @{@"type":@"goods_collection", @"class":[PGGoodsCollectionBanner new]},
                              @{@"type":@"topic", @"class":[PGTopicBanner new]},
                              @{@"type":@"goods", @"class":[PGSingleGoodBanner new]}];
        } paginationCompletion:^(PGRKResponse *response) {
            weakself.feedsResponse = response;
            weakself.feedsArray = response.dataArray;
            weakself.feedsEndFlag = response.pagination.endFlag;
            
            weakself.isPreloadingFeedsNextPage = NO;
        } failure:^(NSError *error) {
            weakself.error = error;
            
            weakself.isPreloadingFeedsNextPage = NO;
        }];
    }
}

- (void)requestGoods
{
    if (!self.goodsResponse) {
        self.goodsResponse = [[PGRKResponse alloc] init];
        self.goodsResponse.pagination.needPerformingBatchUpdate = NO;
        self.goodsResponse.pagination.paginationKey = @"next";
    }
    PGWeakSelf(self);
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Scenario_Goods;
        config.keyPath = @"items";
        config.model = [PGGood new];
        config.pattern = @{@"scenarioId":weakself.scenarioId};
        config.response = weakself.goodsResponse;
    } paginationCompletion:^(PGRKResponse *response) {
        weakself.goodsResponse = response;
        weakself.goodsArray = response.dataArray;
    } failure:^(NSError *error) {
        weakself.error = error;
    }];
}

@end
