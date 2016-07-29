//
//  PGGlobalObject.m
//  Penguin
//
//  Created by Jing Dai on 7/11/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGGlobalObject.h"

@implementation PGGlobalObject

+ (PGGlobalObject *)sharedInstance
{
    static PGGlobalObject *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PGGlobalObject alloc] init];
    });
    
    return sharedInstance;
}

@end
