//
//  PGHistory.m
//  Penguin
//
//  Created by Jing Dai on 31/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGHistory.h"

@implementation PGHistory

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"historyId" : @"id",
             @"time" : @"created_at",
             @"content" : @"content"
             };
}

+ (NSValueTransformer *)timeJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:PGCommentTimeValueTransformer];
}

+ (NSValueTransformer *)historyIdJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:PGStringValueTransformer];
}

+ (NSValueTransformer *)contentJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[PGHistoryContent class]];
}

@end
