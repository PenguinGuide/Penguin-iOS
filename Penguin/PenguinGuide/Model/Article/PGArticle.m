//
//  PGArticle.m
//  Penguin
//
//  Created by Jing Dai on 7/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGArticle.h"

@implementation PGArticle

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"body": @"body",
             @"image": @"image",
             @"title": @"title",
             @"shareUrl": @"share_url"
            };
}

@end
