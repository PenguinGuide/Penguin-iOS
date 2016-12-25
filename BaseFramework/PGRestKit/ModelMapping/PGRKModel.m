//
//  PGRKModel.m
//  Penguin
//
//  Created by Jing Dai on 6/30/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGRKModel.h"

@implementation PGRKModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    [NSException raise:@"No response mapping configured" format:@"response mapping not configured for class %@", NSStringFromClass([self class])];
    
    return nil;
}

+ (id)modelFromDictionary:(NSDictionary *)dict
{
    NSError *error = nil;
    PGRKModel *model = [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:dict error:&error];
    if (!error && model) {
        return model;
    } else {
        NSLog(@"Mapping error: %@", error);
        return nil;
    }
}

+ (NSArray *)modelsFromArray:(NSArray *)array
{
    NSError *error = nil;
    NSArray *models = [MTLJSONAdapter modelsOfClass:[self class] fromJSONArray:array error:&error];
    if (!error && models) {
        return models;
    } else {
        NSLog(@"Mapping error: %@", error);
        return nil;
    }
}

+ (instancetype)stringTransformer:(NSArray *)keys
{
    if (keys.count == 0) {
        return nil;
    } else {
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            id realValue = nil;
            for (NSString *key in keys) {
                if (value[key]) {
                    realValue = value[key];
                    break;
                }
            }
            if ([realValue isKindOfClass:[NSNumber class]]) {
                NSString *stringValue = [NSString stringWithFormat:@"%@", realValue];
                return stringValue;
            } else if ([realValue isKindOfClass:[NSString class]]) {
                return realValue;
            }
            return nil;
        }];
    }
}

@end
