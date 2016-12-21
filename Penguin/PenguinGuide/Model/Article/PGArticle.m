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
             @"subTitle": @"sub_title",
             @"author": @"author",
             @"designer": @"designer",
             @"photographer": @"photographer",
             @"desc": @"desc",
             @"channel": @"channel",
             @"channelIcon": @"channel_icon",
             @"date": @"created_at",
             @"shareUrl": @"share_url",
             @"isLiked": @"is_liked",
             @"isCollected": @"is_collected",
             @"tagsArray": @"tags",
             @"relatedArticlesArray": @"recommends"
            };
}

+ (NSValueTransformer *)dateJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:PGTimeValueTransformer];
}

+ (NSValueTransformer *)tagsArrayJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PGTag class]];
}

+ (NSValueTransformer *)relatedArticlesArrayJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PGArticleBanner class]];
}

@end
