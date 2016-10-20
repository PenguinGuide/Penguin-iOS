//
//  PGCache.h
//  Penguin
//
//  Created by Jing Dai on 8/18/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGCache : NSObject

+ (PGCache *)cacheWithDatabaseName:(NSString *)dbName;

- (void)putObject:(id)object forKey:(NSString *)key intoTable:(NSString *)table;
- (void)deleteObjectForKey:(NSString *)key fromTable:(NSString *)table;

- (id)objectForKey:(NSString *)key fromTable:(NSString *)table;

- (void)clearTable:(NSString *)table;

@end
