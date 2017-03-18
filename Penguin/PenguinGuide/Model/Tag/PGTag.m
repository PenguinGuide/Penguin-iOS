//
//  PGTag.m
//  Penguin
//
//  Created by Jing Dai on 9/19/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGTag.h"

@implementation PGTag

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"image": @"icon_url",
             @"name": @"name",
             @"link": @"link",
             @"tagId": @"id"
             };
}

+ (NSValueTransformer *)tagIdJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:PGStringValueTransformer];
}

@end
