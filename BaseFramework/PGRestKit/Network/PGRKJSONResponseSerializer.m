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

#import "PGRKJSONResponseSerializer.h"
#import "Mantle/Mantle.h"

@interface PGRKJSONResponseSerializer ()

@property (nonatomic, strong) NSMutableDictionary *serializersDict;

@end

@implementation PGRKJSONResponseSerializer

- (nullable id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing  _Nullable *)error
{
    id responseObject = [super responseObjectForResponse:response data:data error:error];
    
    if (responseObject) {
        if (responseObject[kResultKeyPathKey]) {
            if ([responseObject[kResultKeyPathKey] isEqual:@0]) {
                NSString *absoluteUrl = response.URL.absoluteString;
                if (self.serializersDict[absoluteUrl]) {
                    NSDictionary *requestDict = self.serializersDict[absoluteUrl];
                    NSString *keyPath = requestDict[kKeyPathKey];
                    Class modelClass = requestDict[kModelClassKey];
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
    }
    
    return responseObject;
}

- (void)registerKeyPath:(NSString *)keyPath resultKeyPath:(NSString *)resultKeyPath modelClass:(Class)modelClass toTask:(NSURLSessionTask *)task
{
    NSURLRequest *request = [task originalRequest];
    NSString *absoluteUrl = [[request URL] absoluteString];
    
    if (keyPath && keyPath.length > 0 && modelClass) {
        NSDictionary *requestDict = @{kKeyPathKey:keyPath, kResultKeyPathKey:resultKeyPath, kModelClassKey:modelClass};
        [self.serializersDict setObject:requestDict forKey:absoluteUrl];
    }
}

- (void)registerKeyPath:(NSString *)keyPath modelClass:(Class)modelClass toTask:(NSURLSessionTask *)task
{
    NSURLRequest *request = [task originalRequest];
    NSString *absoluteUrl = [[request URL] absoluteString];
    
    if (keyPath && keyPath.length > 0 && modelClass) {
        NSDictionary *requestDict = @{kKeyPathKey:keyPath, kResultKeyPathKey:@"result", kModelClassKey:modelClass};
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
