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
        config.keyPath = @"data";
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
    PGWeakSelf(self);
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Home_HomeFeeds;
        config.keyPath = @"data";
        config.isMockAPI = YES;
        config.mockFileName = @"v1_home_homefeeds.json";
    } completion:^(id response) {
        if (response[@"data"] && [response[@"data"] isKindOfClass:[NSArray class]]) {
            NSMutableArray *models = [NSMutableArray new];
            for (NSDictionary *dict in response[@"data"]) {
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
