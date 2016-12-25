//
//  PGHomeViewModel.m
//  Penguin
//
//  Created by Jing Dai on 7/10/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGHomeViewModel.h"

#import "PGImageBanner.h"
#import "PGScenarioBanner.h"

#import "PGCarouselBanner.h"
#import "PGArticleBanner.h"
#import "PGFlashbuyBanner.h"
#import "PGGoodsCollectionBanner.h"
#import "PGTopicBanner.h"
#import "PGSingleGoodBanner.h"

@interface PGHomeViewModel ()

@property (nonatomic, strong, readwrite) NSArray *recommendsArray;
@property (nonatomic, strong, readwrite) NSArray *channelsArray;
@property (nonatomic, strong, readwrite) NSArray *feedsArray;
@property (nonatomic, strong, readwrite) NSIndexSet *nextPageIndexSet;

@property (nonatomic, strong, readwrite) NSError *recommendsError;
@property (nonatomic, strong, readwrite) NSError *feedsError;

@end

@implementation PGHomeViewModel

- (void)requestData
{
    PGWeakSelf(self);
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Home_Recommends;
        config.keyPath = nil;
    } completion:^(id response) {
        NSDictionary *responseDict = [response firstObject];
        if (responseDict && [responseDict isKindOfClass:[NSDictionary class]]) {
            if (responseDict[@"banners"]) {
                weakself.recommendsArray = [PGImageBanner modelsFromArray:responseDict[@"banners"]];
            }
            if (responseDict[@"channels"]) {
                weakself.channelsArray = [PGScenarioBanner modelsFromArray:responseDict[@"channels"]];
            }
        }
        [weakself requestFeeds];
    } failure:^(NSError *error) {
        weakself.error = error;
        [weakself requestFeeds];
    }];
}

- (void)requestFeeds
{
    if (self.isPreloadingNextPage || self.endFlag) {
        return;
    }
    
    self.isPreloadingNextPage = YES;
    
    if (!self.response) {
        self.response = [[PGRKResponse alloc] init];
        self.response.pagination.needPerformingBatchUpdate = YES;
        self.response.pagination.paginationKey = @"cursor";
        self.response.pagination.paginateSections = YES;
    }
    
    PGParams *params = [PGParams new];
    params[ParamsPerPage] = @10;
    params[ParamsPageCursor] = self.response.pagination.cursor;
    
    PGWeakSelf(self);
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Home_Feeds;
        config.keyPath = @"items";
        config.params = params;
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
        weakself.nextPageIndexSet = response.pagination.nextPageIndexesSet;
        weakself.feedsArray = response.dataArray;
        weakself.endFlag = response.pagination.endFlag;
        
        weakself.isPreloadingNextPage = NO;
    } failure:^(NSError *error) {
        weakself.error = error;
        
        weakself.isPreloadingNextPage = NO;
    }];
}

@end
