//
//  PGGood.m
//  Penguin
//
//  Created by Jing Dai on 8/24/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGGood.h"

@implementation PGGood

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"discountPrice" : @[@"discount_price", @"price"],
             @"originalPrice" : @"original_price",
             @"name" : @"name",
             @"image" : @[@"image", @"image_url"],
             @"unit" : @"unit",
             @"desc" : @"desc",
             @"startTime" : @"begin_at",
             @"endTime" : @"end_at",
             @"link" : @"link",
             @"isNew" : @"is_new",
             @"isCollected": @"collected",
             @"goodId" : @"id",
             @"goodTaobaoId" : @"num_iid",
             @"status" : @"selling_status",
             
             @"bannersArray": @"images",
             @"tagsArray": @"tags",
             @"relatedGoods": @"recommends"
            };
}

+ (NSValueTransformer *)imageJSONTransformer
{
    return [PGGood stringTransformer:@[@"image", @"image_url"]];
}

+ (NSValueTransformer *)goodIdJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:PGStringValueTransformer];
}

+ (NSValueTransformer *)statusJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:PGStringValueTransformer];
}

+ (NSValueTransformer *)discountPriceJSONTransformer
{
    return [PGGood stringTransformer:@[@"discount_price", @"price"]];
}

+ (NSValueTransformer *)originalPriceJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:PGStringValueTransformer];
}

+ (NSValueTransformer *)startTimeJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:PGStringValueTransformer];
}

+ (NSValueTransformer *)endTimeJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:PGStringValueTransformer];
}

+ (NSValueTransformer *)tagsArrayJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PGTag class]];
}

+ (NSValueTransformer *)relatedGoodsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PGGood class]];
}

@end
