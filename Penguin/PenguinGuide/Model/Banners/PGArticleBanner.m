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
             @"image" : @"image",
             @"type" : @"type",
             @"title": @"title",
             @"category" : @"category",
             @"link" : @"link",
             @"readsCount" : @"reads",
             @"commentsCount" : @"comments",
             @"articleId": @"id"
             };
}

@end
