//
//  PGRKJSONRequestSerializer.m
//  Penguin
//
//  Created by Jing Dai on 26/03/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import "PGRKJSONRequestSerializer.h"
#import <CommonCrypto/CommonDigest.h>

@implementation PGRKJSONRequestSerializer

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(id)parameters error:(NSError *__autoreleasing  _Nullable *)error
{
    NSMutableURLRequest *request = [super requestWithMethod:method URLString:URLString parameters:parameters error:error];
    
    NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    if (cachedResponse) {
        NSString *absoluteUrl = request.URL.absoluteString;
        NSString *directory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"com.xinglian.penguin.etags"];
        NSString *fileName = [directory stringByAppendingPathComponent:[self cachedFileNameForKey:absoluteUrl]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
            NSString *etag = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
            if (etag && etag.length > 0) {
                [request addValue:etag forHTTPHeaderField:@"If-None-Match"];
            }
        }
    }
    
    return request;
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

@end
