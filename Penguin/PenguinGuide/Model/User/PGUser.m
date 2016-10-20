//
//  PGUser.m
//  Penguin
//
//  Created by Jing Dai on 21/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGUser.h"

@implementation PGUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"nickname": @"nick_name",
             @"avatar": @"avatar_url",
             @"userId": @"id"
             };
}

@end
