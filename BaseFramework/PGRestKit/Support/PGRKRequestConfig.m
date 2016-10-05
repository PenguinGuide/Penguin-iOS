//
//  PGRKRequestConfig.m
//  Penguin
//
//  Created by Jing Dai on 6/30/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGRKRequestConfig.h"

@implementation PGRKRequestConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.keyPath = @"items";
        self.isMockAPI = NO;
    }
    return self;
}

@end
