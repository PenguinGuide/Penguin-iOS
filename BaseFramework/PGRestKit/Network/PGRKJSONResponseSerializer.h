//
//  PGRKJSONResponseSerializer.h
//  Penguin
//
//  Created by Jing Dai on 6/30/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "PGRKResponse.h"

@interface PGRKJSONResponseSerializer : AFJSONResponseSerializer

- (void)registerKeyPath:(NSString *)keyPath modelClass:(Class)modelClass toTask:(NSURLSessionTask *)task;
- (void)registerKeyPath:(NSString *)keyPath modelClass:(Class)modelClass toTask:(NSURLSessionTask *)task response:(PGRKResponse *)response;
- (void)registerKeyPath:(NSString *)keyPath modelClasses:(NSArray *)modelClasses typeKey:(NSString *)typeKey toTask:(NSURLSessionTask *)task response:(PGRKResponse *)response;

@end
