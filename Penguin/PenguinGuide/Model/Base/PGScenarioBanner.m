//
//  PGScenarioBanner.m
//  Penguin
//
//  Created by Jing Dai on 9/1/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGScenarioBanner.h"

@implementation PGScenarioBanner

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"image": @[@"image", @"image_url"],
             @"title": @"name",
             @"scenarioId": @"id",
             @"link": @"link",
             @"type": @"type"
            };
}

+ (NSValueTransformer *)imageJSONTransformer
{
    return [self stringTransformer:@[@"image", @"image_url"]];
}

+ (NSValueTransformer *)typeJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:PGStringValueTransformer];
}

@end
