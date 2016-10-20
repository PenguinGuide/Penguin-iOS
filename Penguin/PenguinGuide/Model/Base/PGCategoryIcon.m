//
//  PGCategoryIcon.m
//  Penguin
//
//  Created by Jing Dai on 9/1/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGCategoryIcon.h"

@implementation PGCategoryIcon

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"image": @"image",
             @"title": @"name",
             @"categoryId": @"id",
             @"link": @"link"
            };
}

@end
