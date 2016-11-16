//
//  PGExploreViewModel.m
//  Penguin
//
//  Created by Jing Dai on 8/29/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGExploreViewModel.h"

#import "PGCarouselBanner.h"
#import "PGArticleBanner.h"
#import "PGFlashbuyBanner.h"
#import "PGGoodsCollectionBanner.h"
#import "PGTopicBanner.h"
#import "PGSingleGoodBanner.h"
#import "PGImageBanner.h"
#import "PGCategoryIcon.h"

@interface PGExploreViewModel ()

@property (nonatomic, strong, readwrite) NSArray *recommendsArray;
@property (nonatomic, strong, readwrite) NSArray *scenariosArray;
@property (nonatomic, strong, readwrite) NSArray *feedsArray;
@property (nonatomic, strong, readwrite) NSIndexSet *nextPageIndexSet;
@property (nonatomic, assign, readwrite) BOOL reloadFirstPage;

@end

@implementation PGExploreViewModel

- (void)requestData
{
    PGWeakSelf(self);
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Explore_Recommends;
        config.keyPath = nil;
    } completion:^(id response) {
        NSDictionary *responseDict = [response firstObject];
        if (responseDict && [responseDict isKindOfClass:[NSDictionary class]]) {
            if (responseDict[@"banners"]) {
                weakself.recommendsArray = [PGImageBanner modelsFromArray:responseDict[@"banners"]];
            }
            if (responseDict[@"scenarios"]) {
                weakself.scenariosArray = [PGCategoryIcon modelsFromArray:responseDict[@"scenarios"]];
            }
        }
        [weakself requestFeeds];
    } failure:^(NSError *error) {
        [weakself requestFeeds];
    }];
}

- (void)requestFeeds
{
    self.cursor = nil;
    self.endFlag = NO;
    self.reloadFirstPage = NO;
    
    PGParams *params = [PGParams new];
    params[ParamsPageCursor] = self.cursor;
    params[ParamsPerPage] = @10;
    
    PGWeakSelf(self);
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Explore_Feeds;
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
            weakself.reloadFirstPage = YES;
        }
    } failure:^(NSError *error) {
        weakself.error = error;
    }];
}

- (void)loadNextPage
{
    if (!self.isPreloadingNextPage && !self.endFlag) {
        self.isPreloadingNextPage = YES;
        
        PGParams *params = [PGParams new];
        params[ParamsPageCursor] = self.cursor;
        params[ParamsPerPage] = @10;
        
        PGWeakSelf(self);
        [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
            config.route = PG_Explore_Feeds;
            config.keyPath = nil;
            config.params = params;
        } completion:^(id response) {
            NSDictionary *responseDict = [response firstObject];
            if (responseDict[@"items"] && [responseDict[@"items"] isKindOfClass:[NSArray class]]) {
                if ([responseDict[@"items"] count] > 0 && responseDict[@"cursor"]) {
                    weakself.cursor = responseDict[@"cursor"];
                }
                NSMutableArray *models = [NSMutableArray arrayWithArray:weakself.feedsArray];
                NSMutableIndexSet *indexes = [NSMutableIndexSet new];
                NSArray *items = responseDict[@"items"];
                
                int itemsCount = 0;
                for (NSDictionary *dict in items) {
                    if (dict[@"type"]) {
                        if ([dict[@"type"] isEqualToString:@"carousel"]) {
                            PGCarouselBanner *carouseBanner = [PGCarouselBanner modelFromDictionary:dict];
                            if (carouseBanner) {
                                [models addObject:carouseBanner];
                                itemsCount++;
                            }
                        }
                        if ([dict[@"type"] isEqualToString:@"article"]) {
                            PGArticleBanner *articleBanner = [PGArticleBanner modelFromDictionary:dict];
                            if (articleBanner) {
                                [models addObject:articleBanner];
                                itemsCount++;
                            }
                        }
                        if ([dict[@"type"] isEqualToString:@"flashbuy"]) {
                            PGFlashbuyBanner *flashbuyBanner = [PGFlashbuyBanner modelFromDictionary:dict];
                            if (flashbuyBanner) {
                                [models addObject:flashbuyBanner];
                                itemsCount++;
                            }
                        }
                        if ([dict[@"type"] isEqualToString:@"goods_collection"]) {
                            PGGoodsCollectionBanner *goodsCollectionBanner = [PGGoodsCollectionBanner modelFromDictionary:dict];
                            if (goodsCollectionBanner) {
                                [models addObject:goodsCollectionBanner];
                                itemsCount++;
                            }
                        }
                        if ([dict[@"type"] isEqualToString:@"topic"]) {
                            PGTopicBanner *topicBanner = [PGTopicBanner modelFromDictionary:dict];
                            if (topicBanner) {
                                [models addObject:topicBanner];
                                itemsCount++;
                            }
                        }
                        if ([dict[@"type"] isEqualToString:@"goods"]) {
                            PGSingleGoodBanner *singleGoodBanner = [PGSingleGoodBanner modelFromDictionary:dict];
                            if (singleGoodBanner) {
                                [models addObject:singleGoodBanner];
                                itemsCount++;
                            }
                        }
                    }
                }
                for (NSInteger i = weakself.feedsArray.count; i < weakself.feedsArray.count+itemsCount; i++) {
                    [indexes addIndex:i];
                }
                weakself.feedsArray = [NSArray arrayWithArray:models];
                weakself.nextPageIndexSet = [[NSIndexSet alloc] initWithIndexSet:indexes];
                
                if ([responseDict[@"items"] count] == 0) {
                    weakself.endFlag = YES;
                }
            }
            weakself.isPreloadingNextPage = NO;
        } failure:^(NSError *error) {
            weakself.isPreloadingNextPage = NO;
            weakself.error = error;
        }];
    }
}

@end
