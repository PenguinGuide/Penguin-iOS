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
        [weakself requestGoods];
    } failure:^(NSError *error) {
        [weakself requestGoods];
    }];
}

- (void)requestGoods
{
    if (self.isPreloadingNextPage || self.endFlag) {
        return;
    }
    
    self.isPreloadingNextPage = YES;
    
    if (!self.response) {
        self.response = [[PGRKResponse alloc] init];
        self.response.pagination.needPerformingBatchUpdate = NO;
        self.response.pagination.paginateSections = NO;
        self.response.pagination.paginationKey = @"next";
    }
    
    PGParams *params = [PGParams new];
    params[@"per_page"] = @10;
    
    PGWeakSelf(self);
    
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Store_Goods;
        config.params = params;
        config.keyPath = @"items";
        config.model = [PGGood new];
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

- (void)clearPagination
{
    self.endFlag = NO;
    self.isPreloadingNextPage = NO;
    self.response = nil;
}

@end
