//
//  PGMessageContent.m
//  Penguin
//
//  Created by Jing Dai on 27/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGMessageContent.h"

@implementation PGMessageContent

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"avatar" : @"avatar_url",
             @"content" : @[@"comment_content", @"comment"],
             @"replyContent": @"reply_content",
             @"replyId": @"reply_id",
             @"nickname" : @"nick_name"
             };
}

+ (NSValueTransformer *)contentJSONTransformer
{
    return [self stringTransformer:@[@"comment_content", @"comment"]];
}

+ (NSValueTransformer *)replyIdJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:PGStringValueTransformer];
}

@end
