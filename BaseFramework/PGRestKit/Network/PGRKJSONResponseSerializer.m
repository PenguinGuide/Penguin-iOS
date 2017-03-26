//
//  PGRKJSONResponseSerializer.m
//  Penguin
//
//  Created by Jing Dai on 6/30/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

static const NSString *kKeyPathKey = @"kKeyPathKey";
static const NSString *kResultKeyPathKey = @"kResultKeyPathKey";
static const NSString *kModelClassKey = @"kModelClassKey";
static const NSString *kModelClassesKey = @"kModelClassesKey";
static const NSString *kModelsTypeKey = @"kModelsTypeKey";
static const NSString *kResponseKey = @"kResponseKey";
static const NSString *kTaskKey = @"kTaskKey";

#import "PGRKJSONResponseSerializer.h"
#import "Mantle/Mantle.h"
#import <CommonCrypto/CommonDigest.h>

@interface PGRKJSONResponseSerializer ()

@property (nonatomic, strong) NSMutableDictionary *serializersDict;

@end

@implementation PGRKJSONResponseSerializer

- (nullable id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing  _Nullable *)error
{
    NSUInteger responseStatusCode = 200;
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        responseStatusCode = (NSUInteger)[(NSHTTPURLResponse *)response statusCode];
    }
    
    id responseObject;
    
    if (responseStatusCode == 304) {
        NSCachedURLResponse *cachedResponse;
        if (self.serializersDict[response.URL.absoluteString] && self.serializersDict[response.URL.absoluteString][kTaskKey]) {
            NSURLSessionTask *task = self.serializersDict[response.URL.absoluteString][kTaskKey];
            cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:task.currentRequest];
        }
        
        if (cachedResponse) {
            responseObject = [super responseObjectForResponse:cachedResponse.response data:cachedResponse.data error:error];
        } else {
            // cached response was cleared, need to clear cached etag
            NSString *directory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"com.xinglian.penguin.etags"];
            NSString *fileName = [self cachedFileNameForKey:response.URL.absoluteString];
            NSString *cachedFileName = [directory stringByAppendingPathComponent:fileName];
            [[NSFileManager defaultManager] removeItemAtPath:cachedFileName error:nil];
        }
        
        return [self modelsFromResponse:responseObject absoluteUrl:response.URL.absoluteString data:data error:error];
    } else if (responseStatusCode >= 200 && responseStatusCode <= 299) {
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.allHeaderFields[@"Etag"]) {
                NSString *etag = httpResponse.allHeaderFields[@"Etag"];
                if (etag && etag.length > 0) {
                    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"com.xinglian.penguin.etags"];
                    if (![[NSFileManager defaultManager] fileExistsAtPath:directory]) {
                        [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:NO attributes:nil error:nil];
                    }
                    NSString *fileName = [self cachedFileNameForKey:response.URL.absoluteString];
                    NSString *cachedFileName = [directory stringByAppendingPathComponent:fileName];
                    BOOL success = [NSKeyedArchiver archiveRootObject:etag toFile:cachedFileName];
                    NSLog(@"");
                }
            }
        }
        responseObject = [super responseObjectForResponse:response data:data error:error];
        
        return [self modelsFromResponse:responseObject absoluteUrl:response.URL.absoluteString data:data error:error];
    } else {
        id responseObject = [super responseObjectForResponse:response data:data error:error];
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            *error = [NSError errorWithDomain:NSURLErrorDomain code:responseStatusCode userInfo:responseObject];
        } else {
            *error = [NSError errorWithDomain:NSURLErrorDomain code:responseStatusCode userInfo:nil];
        }
        return nil;
    }
}

- (id)modelsFromResponse:(id)responseObject absoluteUrl:(NSString *)absoluteUrl data:(NSData *)data error:(NSError *__autoreleasing  _Nullable *)error
{
    PGRKResponse *paginationResponse = nil;
    
    if (responseObject) {
        if (self.serializersDict[absoluteUrl]) {
            NSDictionary *requestDict = self.serializersDict[absoluteUrl];
            if (requestDict[kResponseKey]) {
                paginationResponse = requestDict[kResponseKey];
                if (paginationResponse.pagination.paginationKey && paginationResponse.pagination.paginationKey.length > 0) {
                    if (responseObject[paginationResponse.pagination.paginationKey] && ![responseObject[paginationResponse.pagination.paginationKey] isKindOfClass:[NSNull class]]) {
                        paginationResponse.pagination.cursor = [NSString stringWithFormat:@"%@", responseObject[paginationResponse.pagination.paginationKey]];
                        if (paginationResponse.pagination.cursor.length == 0) {
                            paginationResponse.pagination.cursor = nil;
                        }
                    } else {
                        paginationResponse.pagination.cursor = nil;
                    }
                }
            }
            if (requestDict[kKeyPathKey]) {
                NSString *keyPath = requestDict[kKeyPathKey];
                if (keyPath.length > 0) {
                    responseObject = [responseObject valueForKeyPath:keyPath];
                    if (!responseObject) {
                        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                        if (*error) {
                            userInfo[NSUnderlyingErrorKey] = *error;
                        }
                        userInfo[NSLocalizedDescriptionKey] = [NSString stringWithFormat:@"Failed to find value for key: %@", keyPath];
                        *error = [NSError errorWithDomain:NSURLErrorDomain code:707 userInfo:userInfo];
                        return nil;
                    }
                }
            }
            
            if (requestDict[kModelClassesKey]) {
                // multiple models
                NSArray *modelClasses = requestDict[kModelClassesKey];
                NSMutableArray *results = [NSMutableArray new];
                for (NSDictionary *dict in responseObject) {
                    if (requestDict[kModelsTypeKey]) {
                        NSString *typeKey = requestDict[kModelsTypeKey];
                        if (dict[typeKey]) {
                            NSString *typeValue = dict[typeKey];
                            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"type", typeValue];
                            NSDictionary *modelClassDict = [[modelClasses filteredArrayUsingPredicate:predicate] firstObject];
                            if (modelClassDict && modelClassDict[@"class"]) {
                                NSError *error = nil;
                                id mappedModel = [MTLJSONAdapter modelOfClass:[modelClassDict[@"class"] class] fromJSONDictionary:dict error:&error];
                                if (!error) {
                                    [results addObject:mappedModel];
                                }
                            }
                        }
                    }
                }
                responseObject = results;
            } else {
                // single model
                Class modelClass = requestDict[kModelClassKey];
                
                NSValueTransformer *valueTransformer = nil;
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    valueTransformer = [MTLJSONAdapter dictionaryTransformerWithModelClass:modelClass];
                } else if ([responseObject isKindOfClass:[NSArray class]]) {
                    valueTransformer = [MTLJSONAdapter arrayTransformerWithModelClass:modelClass];
                }
                if ([valueTransformer conformsToProtocol:@protocol(MTLTransformerErrorHandling)]) {
                    BOOL success = NO;
                    responseObject = [(NSValueTransformer<MTLTransformerErrorHandling> *)valueTransformer transformedValue:responseObject success:&success error:error];
                } else {
                    responseObject = [valueTransformer transformedValue:responseObject];
                }
            }
        }
    }
    if (responseObject && [responseObject isKindOfClass:[NSArray class]] && paginationResponse) {
        if ([responseObject count] > 0) {
            if (paginationResponse.pagination.countPerPage > 0 && [responseObject count] < paginationResponse.pagination.countPerPage) {
                paginationResponse.pagination.cursor = nil;
            }
            if (paginationResponse.pagination.needPerformingBatchUpdate) {
                if (paginationResponse.dataArray.count > 0) {
                    if (paginationResponse.pagination.paginateSections) {
                        NSMutableIndexSet *indexes = [NSMutableIndexSet new];
                        for (int i = paginationResponse.dataArray.count; i < paginationResponse.dataArray.count+[responseObject count]; i++) {
                            [indexes addIndex:i];
                        }
                        paginationResponse.pagination.nextPageIndexesSet = [[NSIndexSet alloc] initWithIndexSet:indexes];
                    } else {
                        NSMutableArray *indexes = [NSMutableArray new];
                        for (int i = paginationResponse.dataArray.count; i < paginationResponse.dataArray.count+[responseObject count]; i++) {
                            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:paginationResponse.pagination.paginatedSection];
                            [indexes addObject:indexPath];
                        }
                        paginationResponse.pagination.nextPageIndexesArray = [NSArray arrayWithArray:indexes];
                    }
                } else {
                    paginationResponse.pagination.nextPageIndexesSet = nil;
                    paginationResponse.pagination.nextPageIndexesArray = nil;
                }
            } else {
                paginationResponse.pagination.nextPageIndexesSet = nil;
                paginationResponse.pagination.nextPageIndexesArray = nil;
            }
            
            NSMutableArray *dataArray = [NSMutableArray arrayWithArray:paginationResponse.dataArray];
            [dataArray addObjectsFromArray:responseObject];
            paginationResponse.dataArray = [NSArray arrayWithArray:dataArray];
            
            if (paginationResponse.pagination.cursor && paginationResponse.pagination.cursor.length > 0) {
                paginationResponse.pagination.endFlag = NO;
            } else {
                paginationResponse.pagination.endFlag = YES;
            }
        } else {
            paginationResponse.pagination.nextPageIndexesSet = nil;
            paginationResponse.pagination.nextPageIndexesArray = nil;
            paginationResponse.pagination.endFlag = YES;
        }
        
        return paginationResponse;
    }
    return responseObject;
}

- (void)registerKeyPath:(NSString *)keyPath modelClass:(Class)modelClass toTask:(NSURLSessionTask *)task
{
    NSURLRequest *request = [task originalRequest];
    NSString *absoluteUrl = [[request URL] absoluteString];
    
    if (keyPath && keyPath.length > 0 && modelClass) {
        NSDictionary *requestDict = @{kKeyPathKey:keyPath, kModelClassKey:modelClass, kTaskKey:task};
        [self.serializersDict setObject:requestDict forKey:absoluteUrl];
    } else {
        NSDictionary *requestDict = @{kModelClassKey:modelClass, kTaskKey:task};
        [self.serializersDict setObject:requestDict forKey:absoluteUrl];
    }
}

- (void)registerKeyPath:(NSString *)keyPath modelClass:(Class)modelClass toTask:(NSURLSessionTask *)task response:(PGRKResponse *)response
{
    NSURLRequest *request = [task originalRequest];
    NSString *absoluteUrl = [[request URL] absoluteString];
    
    if (keyPath && keyPath.length > 0 && modelClass) {
        NSDictionary *requestDict = @{kKeyPathKey:keyPath, kModelClassKey:modelClass, kResponseKey:response, kTaskKey:task};
        [self.serializersDict setObject:requestDict forKey:absoluteUrl];
    } else {
        NSDictionary *requestDict = @{kModelClassKey:modelClass, kResponseKey:response, kTaskKey:task};
        [self.serializersDict setObject:requestDict forKey:absoluteUrl];
    }
}

- (void)registerKeyPath:(NSString *)keyPath modelClasses:(NSArray *)modelClasses typeKey:(NSString *)typeKey toTask:(NSURLSessionTask *)task response:(PGRKResponse *)response
{
    NSURLRequest *request = [task originalRequest];
    NSString *absoluteUrl = [[request URL] absoluteString];
    
    if (keyPath && keyPath.length > 0 && modelClasses) {
        NSDictionary *requestDict = @{kKeyPathKey:keyPath, kModelClassesKey:modelClasses, kModelsTypeKey:typeKey, kResponseKey:response, kTaskKey:task};
        [self.serializersDict setObject:requestDict forKey:absoluteUrl];
    } else {
        NSDictionary *requestDict = @{kModelClassesKey:modelClasses, kModelsTypeKey:typeKey, kResponseKey:response, kTaskKey:task};
        [self.serializersDict setObject:requestDict forKey:absoluteUrl];
    }
}

#pragma mark - <Setters && Getters>

- (NSMutableDictionary *)serializersDict
{
    if (!_serializersDict) {
        _serializersDict = [NSMutableDictionary new];
    }
    
    return _serializersDict;
}

#pragma mark - <Helper Methods>

- (nullable NSString *)cachedFileNameForKey:(nullable NSString *)key {
    const char *str = key.UTF8String;
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%@",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10],
                          r[11], r[12], r[13], r[14], r[15], [key.pathExtension isEqualToString:@""] ? @"" : [NSString stringWithFormat:@".%@", key.pathExtension]];
    
    return filename;
}

#pragma mark - <NSCoding>

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.serializersDict = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(serializersDict))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:self.serializersDict forKey:NSStringFromSelector(@selector(serializersDict))];
}

#pragma mark - <NSCopying>

- (id)copyWithZone:(NSZone *)zone
{
    PGRKJSONResponseSerializer *serializer = [[[self class] allocWithZone:zone] init];
    serializer.serializersDict = [self.serializersDict mutableCopy];
    
    return serializer;
}

@end
