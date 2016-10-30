//
//  PGMe.m
//  Penguin
//
//  Created by Jing Dai on 23/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGMe.h"

@implementation PGMe

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"nickname": @"nick_name",
             @"avatar": @"avatar_url",
             @"userId": @"id",
             @"location": @"location",
             @"sex": @"gender",
             @"birthday": @"birth",
             @"phoneNumber": @"mobile",
             @"collectionCount": @"collection_count",
             @"messageCount": @"message_count"
            };
}

+ (NSValueTransformer *)collectionCountJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:PGStringValueTransformer];
}

+ (NSValueTransformer *)messageCountJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:PGStringValueTransformer];
}

@end
