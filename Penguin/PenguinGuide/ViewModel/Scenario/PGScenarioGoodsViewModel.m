//
//  PGScenarioGoodsViewModel.m
//  Penguin
//
//  Created by Jing Dai on 02/12/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGScenarioGoodsViewModel.h"

@interface PGScenarioGoodsViewModel ()

@property (nonatomic, strong, readwrite) NSArray *goodsArray;

@end

@implementation PGScenarioGoodsViewModel

- (void)requestGoods:(NSString *)scenarioId
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
            config.route = PG_Scenario_Goods;
            config.keyPath = @"items";
            config.params = params;
            config.model = [PGGood new];
            config.pattern = @{@"scenarioId":scenarioId};
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
}

@end
