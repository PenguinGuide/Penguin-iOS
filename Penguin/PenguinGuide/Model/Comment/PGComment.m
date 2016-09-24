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
             @"likes": @"likes",
             @"liked": @"liked",
             @"comment": @"comment",
             @"reply": @"reply",
             @"replyTo": @"reply_to",
             @"time": @"time",
             @"user": @"user"
            };
}

+ (NSValueTransformer *)likesJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:PGStringValueTransformer];
}

+ (NSValueTransformer *)userJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[PGUser class]];
}

@end
