//
//  PGArticleInfo.m
//  Penguin
//
//  Created by Kobe Dai on 29/03/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import "PGArticleInfo.h"

@implementation PGArticleInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"isLiked": @"is_liked",
             @"isCollected": @"is_collected",
             @"likesCount" : @"likes_count",
             @"commentsCount" : @"comments_count",
             @"tagsArray": @"tags",
             @"relatedArticlesArray": @"recommends"
             };
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
