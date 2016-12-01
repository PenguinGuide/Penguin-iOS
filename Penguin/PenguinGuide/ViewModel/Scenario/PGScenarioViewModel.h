//
//  PGScenarioViewModel.h
//  Penguin
//
//  Created by Jing Dai on 8/31/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewModel.h"
#import "PGScenario.h"

@interface PGScenarioViewModel : PGBaseViewModel

@property (nonatomic, strong, readonly) PGScenario *scenario;
@property (nonatomic, strong, readonly) NSArray *feedsArray;
@property (nonatomic, strong, readonly) NSArray *goodsArray;

@property (nonatomic, strong, readonly) PGRKResponse *feedsResponse;
@property (nonatomic, strong, readonly) PGRKResponse *goodsResponse;
@property (nonatomic, assign, readonly) BOOL isPreloadingFeedsNextPage;
@property (nonatomic, assign, readonly) BOOL isPreloadingGoodsNextPage;
@property (nonatomic, assign, readonly) BOOL feedsEndFlag;
@property (nonatomic, assign, readonly) BOOL goodsEndFlag;

- (void)requestScenario:(NSString *)scenarioId;
- (void)requestFeeds;
- (void)requestGoods;

@end
