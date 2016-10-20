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
             @"discountPrice" : @"discount_price",
             @"originalPrice" : @"original_price",
             @"name" : @"name",
             @"image" : @"image",
             @"unit" : @"unit",
             @"desc" : @"desc",
             @"time" : @"time",
             @"link" : @"link",
             @"isNew" : @"is_new",
             @"isCollected": @"collected",
             @"goodId" : @"id",
             @"goodTaobaoId" : @"num_iid",
             
             @"bannersArray": @"images",
             @"tagsArray": @"tags",
             @"relatedArticlesArray": @"related_articles"
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

+ (NSValueTransformer *)timeJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:PGStringValueTransformer];
}

+ (NSValueTransformer *)tagsArrayJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PGTag class]];
}

+ (NSValueTransformer *)relatedArticlesArrayJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PGImageBanner class]];
}

@end
