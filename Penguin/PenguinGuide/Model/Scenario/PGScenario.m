//
//  PGScenario.m
//  Penguin
//
//  Created by Jing Dai on 8/31/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGScenario.h"

@implementation PGScenario

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"image" : @"image",
             @"title": @"title",
             @"categoriesArray" : @"categories"
            };
}

+ (NSValueTransformer *)categoriesArrayJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PGScenarioCategory class]];
}

@end
