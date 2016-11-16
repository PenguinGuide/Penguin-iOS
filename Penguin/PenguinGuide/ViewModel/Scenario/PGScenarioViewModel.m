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

@interface PGScenarioViewModel ()

@property (nonatomic, strong, readwrite) PGScenario *scenario;
@property (nonatomic, strong, readwrite) NSArray *feedsArray;
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
                PGScenarioCategory *category = weakself.scenario.categoriesArray.firstObject;
                if (category) {
                    [weakself requestFeeds:category];
                } else {
                    weakself.feedsArray = [NSArray new];
                }
            }
        } failure:^(NSError *error) {
            weakself.error = error;
        }];
    }
}

- (void)requestFeeds:(PGScenarioCategory *)category
{
    self.cursor = nil;
    
    PGParams *params = [PGParams new];
    params[ParamsPageCursor] = self.cursor;
    params[ParamsPerPage] = @10;
    params[@"category_id"] = category.categoryId;
    
    PGWeakSelf(self);
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Scenario_Feeds;
        config.pattern = @{@"scenarioId":weakself.scenarioId};
        config.keyPath = @"items";
        config.params = params;
    } completion:^(id response) {
        NSDictionary *responseDict = [response firstObject];
        if (responseDict[@"items"] && [responseDict[@"items"] isKindOfClass:[NSArray class]]) {
            if ([responseDict[@"items"] count] > 0 && responseDict[@"cursor"]) {
                weakself.cursor = responseDict[@"cursor"];
            }
            NSMutableArray *models = [NSMutableArray new];
            for (NSDictionary *dict in responseDict[@"items"]) {
                if (dict[@"type"]) {
                    if ([dict[@"type"] isEqualToString:@"carousel"]) {
                        PGCarouselBanner *carouseBanner = [PGCarouselBanner modelFromDictionary:dict];
                        if (carouseBanner) {
                            [models addObject:carouseBanner];
                        }
                    }
                    if ([dict[@"type"] isEqualToString:@"article"]) {
                        PGArticleBanner *articleBanner = [PGArticleBanner modelFromDictionary:dict];
                        if (articleBanner) {
                            [models addObject:articleBanner];
                        }
                    }
                    if ([dict[@"type"] isEqualToString:@"flashbuy"]) {
                        PGFlashbuyBanner *flashbuyBanner = [PGFlashbuyBanner modelFromDictionary:dict];
                        if (flashbuyBanner) {
                            [models addObject:flashbuyBanner];
                        }
                    }
                    if ([dict[@"type"] isEqualToString:@"goods_collection"]) {
                        PGGoodsCollectionBanner *goodsCollectionBanner = [PGGoodsCollectionBanner modelFromDictionary:dict];
                        if (goodsCollectionBanner) {
                            [models addObject:goodsCollectionBanner];
                        }
                    }
                    if ([dict[@"type"] isEqualToString:@"topic"]) {
                        PGTopicBanner *topicBanner = [PGTopicBanner modelFromDictionary:dict];
                        if (topicBanner) {
                            [models addObject:topicBanner];
                        }
                    }
                    if ([dict[@"type"] isEqualToString:@"good"]) {
                        PGSingleGoodBanner *singleGoodBanner = [PGSingleGoodBanner modelFromDictionary:dict];
                        if (singleGoodBanner) {
                            [models addObject:singleGoodBanner];
                        }
                    }
                }
            }
            weakself.feedsArray = [NSArray arrayWithArray:models];
        }
    } failure:^(NSError *error) {
        weakself.error = error;
    }];
}

- (void)requestFeeds:(NSString *)scenarioId categoryId:(NSString *)categoryId
{
    self.cursor = nil;
    
    PGParams *params = [PGParams new];
    params[ParamsPageCursor] = self.cursor;
    params[ParamsPerPage] = @10;
    params[@"category_id"] = categoryId;
    
    PGWeakSelf(self);
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Scenario_Feeds;
        config.pattern = @{@"scenarioId":scenarioId};
        config.keyPath = @"items";
        config.params = params;
    } completion:^(id response) {
        NSDictionary *responseDict = [response firstObject];
        if (responseDict[@"items"] && [responseDict[@"items"] isKindOfClass:[NSArray class]]) {
            if ([responseDict[@"items"] count] > 0 && responseDict[@"cursor"]) {
                weakself.cursor = responseDict[@"cursor"];
            }
            NSMutableArray *models = [NSMutableArray new];
            for (NSDictionary *dict in responseDict[@"items"]) {
                if (dict[@"type"]) {
                    if ([dict[@"type"] isEqualToString:@"carousel"]) {
                        PGCarouselBanner *carouseBanner = [PGCarouselBanner modelFromDictionary:dict];
                        if (carouseBanner) {
                            [models addObject:carouseBanner];
                        }
                    }
                    if ([dict[@"type"] isEqualToString:@"article"]) {
                        PGArticleBanner *articleBanner = [PGArticleBanner modelFromDictionary:dict];
                        if (articleBanner) {
                            [models addObject:articleBanner];
                        }
                    }
                    if ([dict[@"type"] isEqualToString:@"flashbuy"]) {
                        PGFlashbuyBanner *flashbuyBanner = [PGFlashbuyBanner modelFromDictionary:dict];
                        if (flashbuyBanner) {
                            [models addObject:flashbuyBanner];
                        }
                    }
                    if ([dict[@"type"] isEqualToString:@"goods_collection"]) {
                        PGGoodsCollectionBanner *goodsCollectionBanner = [PGGoodsCollectionBanner modelFromDictionary:dict];
                        if (goodsCollectionBanner) {
                            [models addObject:goodsCollectionBanner];
                        }
                    }
                    if ([dict[@"type"] isEqualToString:@"topic"]) {
                        PGTopicBanner *topicBanner = [PGTopicBanner modelFromDictionary:dict];
                        if (topicBanner) {
                            [models addObject:topicBanner];
                        }
                    }
                    if ([dict[@"type"] isEqualToString:@"good"]) {
                        PGSingleGoodBanner *singleGoodBanner = [PGSingleGoodBanner modelFromDictionary:dict];
                        if (singleGoodBanner) {
                            [models addObject:singleGoodBanner];
                        }
                    }
                }
            }
            weakself.feedsArray = [NSArray arrayWithArray:models];
        }
    } failure:^(NSError *error) {
        weakself.error = error;
    }];
}

- (void)loadNextPage
{
    
}

@end
