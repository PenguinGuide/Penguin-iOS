//
//  PGRKResponse.m
//  Penguin
//
//  Created by Jing Dai on 17/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGRKResponse.h"

@implementation PGRKResponse

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataArray = [NSArray new];
        self.pagination = [PGRKPagination new];
    }
    return self;
}

@end
