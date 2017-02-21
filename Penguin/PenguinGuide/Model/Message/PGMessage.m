//
//  PGMessage.m
//  Penguin
//
//  Created by Jing Dai on 27/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGMessage.h"

@implementation PGMessage

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"content" : @"content",
             @"messageId" : @"id",
             @"link" : @"link"
             };
}

+ (NSValueTransformer *)contentJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[PGMessageContent class]];
}

@end
