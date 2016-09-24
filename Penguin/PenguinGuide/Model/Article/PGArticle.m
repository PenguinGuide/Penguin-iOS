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
             @"desc": @"desc",
             @"channel": @"channel",
             @"date": @"date",
             @"shareUrl": @"share_url",
             @"tagsArray": @"tags",
             @"relatedArticlesArray": @"related_articles"
            };
}

+ (NSValueTransformer *)tagsArrayJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PGTag class]];
}

+ (NSValueTransformer *)relatedArticlesArrayJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PGImageBanner class]];
}

@end
