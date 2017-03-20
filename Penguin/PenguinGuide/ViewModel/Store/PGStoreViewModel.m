//
//  PGStoreViewModel.m
//  Penguin
//
//  Created by Jing Dai on 8/31/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGStoreViewModel.h"

#import "PGScenarioBanner.h"
#import "PGFlashbuyBanner.h"
#import "PGGoodsCollectionBanner.h"
#import "PGSingleGoodBanner.h"

@interface PGStoreViewModel ()

@property (nonatomic, strong, readwrite) NSArray *scenariosArray;
@property (nonatomic, strong, readwrite) NSArray *salesArray;
@property (nonatomic, strong, readwrite) NSArray *collectionsArray;
@property (nonatomic, strong, readwrite) NSArray *goodsArray;

@end

@implementation PGStoreViewModel

- (void)requestData
{
    PGWeakSelf(self);
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Store_Recommends;
        config.keyPath = nil;
    } completion:^(id response) {
        NSDictionary *responseDict = [response firstObject];
        if (responseDict && [responseDict isKindOfClass:[NSDictionary class]]) {
            if (responseDict[@"weekly"] && [responseDict[@"weekly"] isKindOfClass:[NSArray class]]) {
                NSMutableArray *salesArray = [NSMutableArray new];
                for (id banner in responseDict[@"weekly"]) {
                    if (banner[@"type"]) {
                        if ([banner[@"type"] isEqualToString:@"flashbuy"]) {
                            PGFlashbuyBanner *flashbuyBanner = [PGFlashbuyBanner modelFromDictionary:banner];
                            if (flashbuyBanner) {
                                [salesArray addObject:flashbuyBanner];
                            }
                        }
                        if ([banner[@"type"] isEqualToString:@"goods"]) {
                            PGSingleGoodBanner *singleGoodBanner = [PGSingleGoodBanner modelFromDictionary:banner];
                            if (singleGoodBanner) {
                                [salesArray addObject:singleGoodBanner];
                            }
                        }
                    }
                }
                weakself.salesArray = [NSArray arrayWithArray:salesArray];
            }
            if (responseDict[@"recommends"] && [responseDict[@"recommends"] isKindOfClass:[NSArray class]]) {
                NSMutableArray *collectionsArray = [NSMutableArray new];
                for (id banner in responseDict[@"recommends"]) {
                    if (banner[@"type"]) {
                        if ([banner[@"type"] isEqualToString:@"goods_collection"]) {
                            PGGoodsCollectionBanner *goodsCollectionBanner = [PGGoodsCollectionBanner modelFromDictionary:banner];
                            if (goodsCollectionBanner) {
                                [collectionsArray addObject:goodsCollectionBanner];
                            }
                        }
                    }
                }
                weakself.collectionsArray = [NSArray arrayWithArray:collectionsArray];
            }
            if (responseDict[@"scenarios"] && [responseDict[@"scenarios"] isKindOfClass:[NSArray class]]) {
                weakself.scenariosArray = [PGScenarioBanner modelsFromArray:responseDict[@"scenarios"]];
            }
        }
        [weakself requestFeeds];
    } failure:^(NSError *error) {
        [weakself requestFeeds];
    }];
}

- (void)requestFeeds
{
//    if (self.isPreloadingNextPage || self.endFlag) {
//        return;
//    }
//    
//    self.isPreloadingNextPage = YES;
//    
//    if (!self.response) {
//        self.response = [[PGRKResponse alloc] init];
//        self.response.pagination.needPerformingBatchUpdate = NO;
//        self.response.pagination.paginationKey = @"cursor";
//    }
//    
//    PGWeakSelf(self);
//    
//    PGParams *params = [PGParams new];
//    params[ParamsPerPage] = @10;
//    params[ParamsPageCursor] = self.response.pagination.cursor;
//    
//    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
//        config.route = PG_Home_Feeds;
//        config.keyPath = @"items";
//        config.params = params;
//        config.typeKey = @"type";
//        config.response = weakself.response;
//        config.models = @[@{@"type":@"carousel", @"class":[PGCarouselBanner new]},
//                          @{@"type":@"article", @"class":[PGArticleBanner new]},
//                          @{@"type":@"flashbuy", @"class":[PGFlashbuyBanner new]},
//                          @{@"type":@"goods_collection", @"class":[PGGoodsCollectionBanner new]},
//                          @{@"type":@"topic", @"class":[PGTopicBanner new]},
//                          @{@"type":@"goods", @"class":[PGSingleGoodBanner new]}];
//    } paginationCompletion:^(PGRKResponse *response) {
//        weakself.response = response;
//        weakself.feedsArray = response.dataArray;
//        weakself.endFlag = response.pagination.endFlag;
//        
//        weakself.isPreloadingNextPage = NO;
//    } failure:^(NSError *error) {
//        weakself.error = error;
//        
//        weakself.isPreloadingNextPage = NO;
//    }];
}

- (void)clearPagination
{
    self.endFlag = NO;
    self.isPreloadingNextPage = NO;
    self.response = nil;
}

@end
