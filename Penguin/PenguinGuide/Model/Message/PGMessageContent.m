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
             @"content" : @"comment",
             @"nickname" : @"nick_name"
             };
}

@end
