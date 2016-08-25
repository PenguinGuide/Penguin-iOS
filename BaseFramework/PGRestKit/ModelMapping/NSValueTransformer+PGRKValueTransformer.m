//
//  NSValueTransformer+PGRKValueTransformer.m
//  Penguin
//
//  Created by Jing Dai on 8/24/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "NSValueTransformer+PGRKValueTransformer.h"
#import <Mantle/Mantle.h>

NSString *const PGStringValueTransformer = @"PGStringValueTransformer";

@implementation NSValueTransformer (PGRKValueTransformer)

+ (void)load
{
    @autoreleasepool {
        // string value transformer
        MTLValueTransformer *stringValueTransformer = [MTLValueTransformer transformerUsingReversibleBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            if (value == nil) return nil;
            
            if ([value isKindOfClass:[NSNumber class]]) {
                NSString *stringValue = [NSString stringWithFormat:@"%@", value];
                return stringValue;
            } else if ([value isKindOfClass:[NSString class]]) {
                return value;
            }else{
                return nil;
            }
        }];
        [NSValueTransformer setValueTransformer:stringValueTransformer forName:PGStringValueTransformer];
    }
}

@end
