//
//  PGRKParams.m
//  Penguin
//
//  Created by Jing Dai on 6/30/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGRKParams.h"

@implementation PGRKParams

- (id)init
{
    if (self = [super init]) {
        self.dict = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)otherDictionary
{
    if (self = [super init]) {
        self.dict = [[NSMutableDictionary alloc] initWithDictionary:otherDictionary];
    }
    
    return self;
}

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (anObject != nil) {
        [self.dict setObject:anObject forKey:aKey];
    }
}

- (id)objectForKey:(id)aKey
{
    return [self.dict objectForKey:aKey];
}

- (void)removeObjectForKey:(id)aKey
{
    [self.dict removeObjectForKey:aKey];
}

- (NSUInteger)count
{
    return self.dict.count;
}

- (NSEnumerator *)keyEnumerator
{
    return self.dict.keyEnumerator;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return self.dict;
}

@end
