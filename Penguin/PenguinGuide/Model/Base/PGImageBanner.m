//
//  PGImageBanner.m
//  Penguin
//
//  Created by Jing Dai on 7/12/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGImageBanner.h"

@implementation PGImageBanner

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"image" : @"image",
             @"link" : @"link",
             @"type": @"type",
             @"bannerId" : @"id"
            };
}

@end
