//
//  PGRKPagination.m
//  Penguin
//
//  Created by Jing Dai on 16/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGRKPagination.h"

@implementation PGRKPagination

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.paginationKey = nil;
        self.cursor = nil;
        self.paginatedSection = 0;
    }
    return self;
}

@end
