//
//  PGScenarioViewModel.m
//  Penguin
//
//  Created by Jing Dai on 8/31/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGScenarioViewModel.h"

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
        } failure:^(NSError *error) {
            weakself.error = error;
        }];
    }
}

@end
