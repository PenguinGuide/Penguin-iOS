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
             @"subTitle" : @"beginning",
             @"date" : @"created_at",
             @"coverTitle": @"cover_title",
             @"channel" : @"channel",
             @"channelIcon" : @"channel_icon",
             @"link" : @"link",
             @"likesCount" : @[@"likes", @"favor_count"],
             @"commentsCount" : @[@"comments", @"comment_count"],
             @"articleId": @"id",
             @"status" : @"status",
             @"desc" : @"desc",
             @"isCollected": @"is_collected",
             @"isNew": @"is_new"
             };
}

+ (NSValueTransformer *)articleIdJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:PGStringValueTransformer];
}

+ (NSValueTransformer *)dateJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:PGTimeValueTransformer];
}

+ (NSValueTransformer *)likesCountJSONTransformer
{
    return [PGArticleBanner stringTransformer:@[@"likes", @"favor_count"]];
}

+ (NSValueTransformer *)commentsCountJSONTransformer
{
    return [PGArticleBanner stringTransformer:@[@"comments", @"comment_count"]];
}

+ (NSValueTransformer *)statusJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:PGStringValueTransformer];
}

@end
