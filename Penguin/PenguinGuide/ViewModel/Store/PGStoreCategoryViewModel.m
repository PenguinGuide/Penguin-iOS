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
@property (nonatomic, strong, readwrite) NSString *categoryId;

@end

@implementation PGStoreCategoryViewModel

- (void)requestCategoryGoods:(NSString *)categoryId
{
    PGWeakSelf(self);
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Store_Category_Goods;
        config.model = [PGGood new];
        config.pattern = @{@"categoryId":categoryId};
        config.keyPath = @"items";
    } completion:^(id response) {
        weakself.goodsArray = response;
    } failure:^(NSError *error) {
        weakself.error = error;
    }];
}

- (void)requestCategoryGoods:(NSString *)categoryId sort:(NSString *)sort
{
    PGParams *params = [PGParams new];
    params[@"sort"] = sort;
    
    PGWeakSelf(self);
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Store_Category_Goods;
        config.model = [PGGood new];
        config.params = params;
        config.pattern = @{@"categoryId":categoryId};
        config.keyPath = @"items";
    } completion:^(id response) {
        weakself.goodsArray = response;
    } failure:^(NSError *error) {
        weakself.error = error;
    }];
}

@end
