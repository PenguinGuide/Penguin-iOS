//
//  PGStoreCategoryViewModel.m
//  Penguin
//
//  Created by Jing Dai on 9/1/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGStoreCategoryViewModel.h"

@interface PGStoreCategoryViewModel ()

@property (nonatomic, strong, readwrite) NSArray *goodsArray;

@end

@implementation PGStoreCategoryViewModel

- (void)requestData
{
    PGWeakSelf(self);
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Store_Category_Goods;
        config.model = [PGGood new];
        config.keyPath = @"data";
        config.isMockAPI = YES;
        config.mockFileName = @"v1_goods_category_categoryid.json";
    } completion:^(id response) {
        weakself.goodsArray = response;
    } failure:^(NSError *error) {
        
    }];
}

@end
