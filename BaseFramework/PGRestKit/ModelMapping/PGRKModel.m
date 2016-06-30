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

+ (PGRKModel *)modelFromDictionary:(NSDictionary *)dict
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

@end
