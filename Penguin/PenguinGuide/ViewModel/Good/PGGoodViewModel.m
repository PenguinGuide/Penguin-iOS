//
//  PGGoodViewModel.m
//  Penguin
//
//  Created by Jing Dai on 28/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGGoodViewModel.h"

@interface PGGoodViewModel ()

@property (nonatomic, strong, readwrite) PGGood *good;
@property (nonatomic, strong, readwrite) NSArray *relatedGoods;

@end

@implementation PGGoodViewModel

- (void)requestData
{
    PGWeakSelf(self);
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Good;
        config.keyPath = nil;
        config.model = [PGGood new];
        config.isMockAPI = YES;
        config.mockFileName = @"v1_good_goodid.json";
    } completion:^(id response) {
        weakself.good = [response firstObject];
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestRelatedGoods
{
    PGWeakSelf(self);
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Related_Goods;
        config.keyPath = @"items";
        config.model = [PGGood new];
        config.isMockAPI = YES;
        config.mockFileName = @"v1_goods_related_goodid.json";
    } completion:^(id response) {
        weakself.relatedGoods = response;
    } failure:^(NSError *error) {
        
    }];
}

@end
