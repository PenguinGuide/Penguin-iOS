//
//  PGGoodsCollectionBanner.m
//  Penguin
//
//  Created by Jing Dai on 8/24/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGGoodsCollectionBanner.h"
#import "PGGood.h"

@implementation PGGoodsCollectionBanner

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"title" : @"title",
             @"desc" : @"desc",
             @"goodsArray" : @"goods"
            };
}

+ (NSValueTransformer *)goodsArrayJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PGGood class]];
}

@end
