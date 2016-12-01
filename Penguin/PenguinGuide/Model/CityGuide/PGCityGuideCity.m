//
//  PGCityGuideCity.m
//  Penguin
//
//  Created by Jing Dai on 29/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGCityGuideCity.h"

@implementation PGCityGuideCity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"cityName" : @"name",
             @"cityId" : @"id"
             };
}

@end
