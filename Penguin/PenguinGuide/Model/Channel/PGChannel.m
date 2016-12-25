//
//  PGChannel.m
//  Penguin
//
//  Created by Jing Dai on 8/26/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGChannel.h"

@implementation PGChannel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"totalArticles" : @"total_articles",
             @"desc" : @"description",
             @"channelId" : @"id",
             @"icon" : @"icon_url",
             @"name" : @"name",
             @"categoriesArray" : @"categories"
            };
}

+ (NSValueTransformer *)totalArticlesJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:PGStringValueTransformer];
}

+ (NSValueTransformer *)categoriesArrayJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PGChannelCategory class]];
}

@end
