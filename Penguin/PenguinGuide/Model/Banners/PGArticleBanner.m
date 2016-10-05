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
             @"channel" : @"channel",
             @"link" : @"link",
             @"likesCount" : @"likes",
             @"commentsCount" : @"comments",
             @"articleId": @"id"
             };
}

+ (NSValueTransformer *)likesCountJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:PGStringValueTransformer];
}

+ (NSValueTransformer *)commentsCountJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:PGStringValueTransformer];
}

@end
