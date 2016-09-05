//
//  PGTopic.m
//  Penguin
//
//  Created by Jing Dai on 9/5/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGTopic.h"

@implementation PGTopic

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"image": @"image",
             @"title": @"title",
             @"aritclesArray": @"articles",
             @"goodsArray": @"goods"
            };
}

+ (NSValueTransformer *)articlesArrayJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PGArticleBanner class]];
}

+ (NSValueTransformer *)goodsArrayJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PGGood class]];
}

@end
