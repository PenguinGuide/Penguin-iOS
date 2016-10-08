//
//  PGHomeViewModel.m
//  Penguin
//
//  Created by Jing Dai on 7/10/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGHomeViewModel.h"

#import "PGCarouselBanner.h"
#import "PGArticleBanner.h"
#import "PGFlashbuyBanner.h"
#import "PGGoodsCollectionBanner.h"
#import "PGTopicBanner.h"
#import "PGSingleGoodBanner.h"
#import "PGImageBanner.h"

@interface PGHomeViewModel ()

@property (nonatomic, strong, readwrite) NSArray *recommendsArray;
@property (nonatomic, strong, readwrite) NSArray *feedsArray;

@end

@implementation PGHomeViewModel

- (void)requestData
{
    PGWeakSelf(self);
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Home_Recommends;
        config.keyPath = @"items";
        config.model = [PGImageBanner new];
        config.isMockAPI = YES;
        config.mockFileName = @"v1_home_recommends.json";
    } completion:^(id response) {
        weakself.recommendsArray = response;
        [weakself requestFeeds];
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestFeeds
{
    self.page = 1;
    
    PGParams *params = [PGParams new];
    params[ParamsPage] = @(self.page);
    params[ParamsPerPage] = @10;
    
    PGWeakSelf(self);
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Home_Feeds;
        config.keyPath = nil;
        config.params = params;
//        config.isMockAPI = YES;
//        config.mockFileName = @"v1_home_feeds.json";
    } completion:^(id response) {
        if (response[@"items"] && [response[@"items"] isKindOfClass:[NSArray class]]) {
            if ([response[@"items"] count] > 0) {
                weakself.page++;
            }
            NSMutableArray *models = [NSMutableArray new];
            for (NSDictionary *dict in response[@"items"]) {
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
        
    }];
}

- (void)loadNextPage
{
    PGParams *params = [PGParams new];
    params[ParamsPage] = @(self.page);
    params[ParamsPerPage] = @10;
    
    // NOTE: use reloadData or reloadSections http://blog.csdn.net/iosswift/article/details/50001145
    
    PGWeakSelf(self);
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Home_Feeds;
        config.keyPath = nil;
        config.params = params;
//        config.isMockAPI = YES;
//        config.mockFileName = @"v1_home_feeds.json";
    } completion:^(id response) {
        if (response[@"items"] && [response[@"items"] isKindOfClass:[NSArray class]]) {
            if ([response[@"items"] count] > 0) {
                weakself.page++;
            }
            NSMutableArray *models = [NSMutableArray arrayWithArray:weakself.feedsArray];
            for (NSDictionary *dict in response[@"items"]) {
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
        
    }];
}

@end
