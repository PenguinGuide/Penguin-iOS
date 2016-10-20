//
//  PGComment.m
//  Penguin
//
//  Created by Jing Dai on 21/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGComment.h"

@implementation PGComment

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"likes": @"favor_count",
             @"liked": @"liked",
             @"content": @"content",
             @"time": @"created_at",
             @"user": @"user",
             
             @"replyComment": @"reply"
            };
}

+ (NSValueTransformer *)likesJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:PGStringValueTransformer];
}

+ (NSValueTransformer *)timeJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:PGCommentTimeValueTransformer];
}

+ (NSValueTransformer *)userJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[PGUser class]];
}

+ (NSValueTransformer *)replyCommentJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[PGComment class]];
}

@end
