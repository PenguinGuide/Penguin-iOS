//
//  PGCarouselBanner.m
//  Penguin
//
//  Created by Jing Dai on 7/12/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGCarouselBanner.h"
#import "PGImageBanner.h"

@implementation PGCarouselBanner

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"banners" : @"images"
             };
}

+ (NSValueTransformer *)bannersJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PGImageBanner class]];
}

@end
