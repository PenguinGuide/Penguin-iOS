//
//  PGRKJSONResponseSerializer.h
//  Penguin
//
//  Created by Jing Dai on 6/30/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface PGRKJSONResponseSerializer : AFJSONResponseSerializer

- (void)registerKeyPath:(NSString *)keyPath modelClass:(Class)modelClass toTask:(NSURLSessionTask *)task;
- (void)registerKeyPath:(NSString *)keyPath resultKeyPath:(NSString *)resultKeyPath modelClass:(Class)modelClass toTask:(NSURLSessionTask *)task;

@end
