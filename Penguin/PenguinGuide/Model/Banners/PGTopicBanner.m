//
//  PGTopicBanner.m
//  Penguin
//
//  Created by Jing Dai on 8/24/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGTopicBanner.h"
#import "PGGood.h"

@implementation PGTopicBanner

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"image" : @"image",
             @"link" : @"link",
             @"goodsArray" : @"goods"
            };
}

+ (NSValueTransformer *)goodsArrayJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PGGood class]];
}

@end
