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

- (NSString *)paramsString
{
    NSString *reStr = @"";
    for (int i = 0; i < [self count]; i++) {
        NSString *key = self.allKeys[i];
        NSString *value = self[key];
        if (i != 0) {
            reStr = [reStr stringByAppendingString:@"&"];
        }
        reStr = [reStr stringByAppendingFormat:@"%@=%@", key, [self urlEncode:value]];
    }
    return reStr;
}

- (NSString *)urlEncode:(NSString *)str
{
    NSArray *escapeChars = [NSArray arrayWithObjects:@";" , @"/" , @"?" , @":" ,
                            @"@" , @"&" , @"=" , @"+" ,    @"$" , @"," ,
                            @"!", @"'", @"(", @")", @"*", nil];
    
    NSArray *replaceChars = [NSArray arrayWithObjects:@"%3B" , @"%2F", @"%3F" , @"%3A" ,
                             @"%40" , @"%26" , @"%3D" , @"%2B" , @"%24" , @"%2C" ,
                             @"%21", @"%27", @"%28", @"%29", @"%2A", nil];
    
    NSInteger len = [escapeChars count];
    
    NSMutableString *temp = [[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    int i;
    for (i = 0; i < len; i++) {
        [temp replaceOccurrencesOfString:[escapeChars objectAtIndex:i]
                              withString:[replaceChars objectAtIndex:i]
                                 options:NSLiteralSearch
                                   range:NSMakeRange(0, [temp length])];
    }
    
    NSString *outStr = [NSString stringWithString: temp];
    
    return outStr;
}

@end
