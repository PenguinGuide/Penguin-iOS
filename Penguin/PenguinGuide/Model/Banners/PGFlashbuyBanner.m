//
//  PGFlashbuyBanner.m
//  Penguin
//
//  Created by Jing Dai on 8/24/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGFlashbuyBanner.h"

@implementation PGFlashbuyBanner

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"goodsArray" : @"goods"
            };
}

+ (NSValueTransformer *)goodsArrayJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PGGood class]];
}

@end
