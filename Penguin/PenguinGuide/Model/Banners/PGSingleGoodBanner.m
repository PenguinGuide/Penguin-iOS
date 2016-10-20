//
//  PGSingleGoodBanner.m
//  Penguin
//
//  Created by Jing Dai on 8/24/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGSingleGoodBanner.h"

@implementation PGSingleGoodBanner

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"discountPrice" : @"discount_price",
             @"originalPrice" : @"original_price",
             @"name" : @"name",
             @"image" : @"image",
             @"unit" : @"unit",
             @"desc" : @"desc",
             @"link" : @"link",
             @"goodsId" : @"id"
            };
}

+ (NSValueTransformer *)discountPriceJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:PGStringValueTransformer];
}

+ (NSValueTransformer *)originalPriceJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:PGStringValueTransformer];
}

@end
