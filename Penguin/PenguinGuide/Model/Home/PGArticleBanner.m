//
//  PGArticleBanner.m
//  Penguin
//
//  Created by Jing Dai on 7/12/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGArticleBanner.h"

@implementation PGArticleBanner

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"desc" : @"desc",
             @"banners" : @"images"
             };
}

+ (NSValueTransformer *)bannersJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PGImageBanner class]];
}

@end
