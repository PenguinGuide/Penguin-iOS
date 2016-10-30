//
//  PGCollection.m
//  Penguin
//
//  Created by Jing Dai on 30/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGCollection.h"

@implementation PGCollection

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"icon" : @"channel_icon",
             @"name" : @"name",
             @"channelId" : @"channel_id",
             @"count" : @"count"
             };
}

+ (NSValueTransformer *)countJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:PGStringValueTransformer];
}

+ (NSValueTransformer *)channelIdJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:PGStringValueTransformer];
}

@end
