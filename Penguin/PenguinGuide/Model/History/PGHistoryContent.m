//
//  PGHistoryContent.m
//  Penguin
//
//  Created by Jing Dai on 31/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGHistoryContent.h"

@implementation PGHistoryContent

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"content" : @"content",
             @"image" : @"image",
             @"articleTitle" : @"article_title",
             @"link" : @"link",
             @"articleId" : @"article_id"
             };
}

+ (NSValueTransformer *)articleIdJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:PGStringValueTransformer];
}

@end
