//
//  PGScenarioFeedsViewModel.m
//  Penguin
//
//  Created by Jing Dai on 02/12/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGCarouselBanner.h"
#import "PGArticleBanner.h"
#import "PGFlashbuyBanner.h"
#import "PGGoodsCollectionBanner.h"
#import "PGTopicBanner.h"
#import "PGSingleGoodBanner.h"

#import "PGScenarioFeedsViewModel.h"

@interface PGScenarioFeedsViewModel ()

@property (nonatomic, strong, readwrite) NSArray *feedsArray;

@end

@implementation PGScenarioFeedsViewModel

- (void)requestFeeds:(NSString *)scenarioId
{
    if (self.isPreloadingNextPage || self.endFlag) {
        return;
    }
    
    if (scenarioId && scenarioId.length > 0) {
        self.isPreloadingNextPage = YES;
        
        if (!self.response) {
            self.response = [[PGRKResponse alloc] init];
            self.response.pagination.needPerformingBatchUpdate = NO;
            self.response.pagination.paginationKey = @"cursor";
        }
        
        PGWeakSelf(self);
        
        PGParams *params = [PGParams new];
        params[ParamsPerPage] = @10;
        params[ParamsPageCursor] = self.response.pagination.cursor;
        
        [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
            config.route = PG_Scenario_Feeds;
            config.keyPath = @"items";
            config.params = params;
            config.pattern = @{@"scenarioId":scenarioId};
            config.typeKey = @"type";
            config.response = weakself.response;
            config.models = @[@{@"type":@"carousel", @"class":[PGCarouselBanner new]},
                              @{@"type":@"article", @"class":[PGArticleBanner new]},
                              @{@"type":@"flashbuy", @"class":[PGFlashbuyBanner new]},
                              @{@"type":@"goods_collection", @"class":[PGGoodsCollectionBanner new]},
                              @{@"type":@"topic", @"class":[PGTopicBanner new]},
                              @{@"type":@"goods", @"class":[PGSingleGoodBanner new]}];
        } paginationCompletion:^(PGRKResponse *response) {
            weakself.response = response;
            weakself.feedsArray = response.dataArray;
            weakself.endFlag = response.pagination.endFlag;
            
            weakself.isPreloadingNextPage = NO;
        } failure:^(NSError *error) {
            weakself.error = error;
            
            weakself.isPreloadingNextPage = NO;
        }];
    }
}

@end
