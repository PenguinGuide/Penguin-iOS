//
//  PGChannelCategory.m
//  Penguin
//
//  Created by Jing Dai on 8/26/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGChannelCategory.h"

@implementation PGChannelCategory

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"image" : @"icon_url",
             @"categoryId" : @"id"
            };
}

@end
