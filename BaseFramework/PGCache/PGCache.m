//
//  PGCache.m
//  Penguin
//
//  Created by Jing Dai on 8/18/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define DocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

static const NSString *SELECT_ITEM_QUERY = @"SELECT json FROM %@ WHERE id = ? Limit 1";
static const NSString *UPDATE_ITEM_QUERY = @"REPLACE INTO %@ (id, json) VALUES (?, ?)";
static const NSString *DELETE_ITEM_QUERY = @"DELETE FROM %@ WHERE id = ?";
static const NSString *CREATE_TABLE_QUERY =
@"CREATE TABLE IF NOT EXISTS %@ ( \
id TEXT NOT NULL, \
json TEXT NOT NULL, \
PRIMARY KEY(id)) \
";
static const NSString *DROP_TABLE_QUERY = @"DROP TABLE '%@'";

#import "PGCache.h"
#import "FMDB.h"

@interface PGCache ()

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

@end

@implementation PGCache

- (id)initWithDatabaseName:(NSString *)dbName
{
    if (self = [super init]) {
        self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:[DocumentPath stringByAppendingPathComponent:dbName]];
    }
    
    return self;
}

+ (PGCache *)cacheWithDatabaseName:(NSString *)dbName
{
    PGCache *cache = [[PGCache alloc] initWithDatabaseName:dbName];
    
    return cache;
}

- (void)putObject:(id)object forKey:(NSString *)key intoTable:(NSString *)table
{
    BOOL success = [self checkTableAndCreate:table];
    
    if (success) {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:object options:0 error:&error];
        if (error) {
            return;
        }
        NSString *jsonStr = [[NSString alloc] initWithData:data encoding:(NSUTF8StringEncoding)];
        
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            NSString *sql = [NSString stringWithFormat:UPDATE_ITEM_QUERY, table];
            [db executeUpdate:sql, key, jsonStr];
        }];
    }
}

- (void)deleteObjectForKey:(NSString *)key fromTable:(NSString *)table
{
    BOOL success = [self checkTable:table];
    
    if (success) {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            NSString *sql = [NSString stringWithFormat:DELETE_ITEM_QUERY, table];
            [db executeUpdate:sql, key];
        }];
    }
}

- (id)objectForKey:(NSString *)key fromTable:(NSString *)table
{
    BOOL success = [self checkTable:table];
    
    if (success) {
        __block NSString *json = nil;
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            NSString *sql = [NSString stringWithFormat:SELECT_ITEM_QUERY, table];
            FMResultSet *resultSet = [db executeQuery:sql, key];
            if ([resultSet next]) {
                json = [resultSet stringForColumn:@"json"];
            }
            [resultSet close];
        }];
        
        if (json) {
            NSError *error = nil;
            id result = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
                                                        options:(NSJSONReadingAllowFragments)
                                                          error:&error];
            if (error) {
                return nil;
            } else {
                return result;
            }
        }
    }
    
    return nil;
}

- (void)clearTable:(NSString *)table
{
    BOOL success = [self checkTable:table];
    
    if (success) {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            NSString *sql = [NSString stringWithFormat:DROP_TABLE_QUERY, table];
            [db executeUpdate:sql];
        }];
    }
}

- (BOOL)checkTable:(NSString *)tableName
{
    __block BOOL success = NO;
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        success = [db tableExists:tableName];
    }];
    
    return success;
}

- (BOOL)checkTableAndCreate:(NSString *)tableName
{
    __block BOOL success = NO;
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        success = [db tableExists:tableName];
    }];
    
    if (success) {
        return YES;
    } else {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            NSString *sql = [NSString stringWithFormat:CREATE_TABLE_QUERY, tableName];
            success = [db executeUpdate:sql];
        }];
        
        return success;
    }
}

@end
