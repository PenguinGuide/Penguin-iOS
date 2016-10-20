//
//  PGScenarioCategory.m
//  Penguin
//
//  Created by Jing Dai on 8/31/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGScenarioCategory.h"

@implementation PGScenarioCategory

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"image" : @"image",
             @"categoryId" : @"id"
            };
}

@end
