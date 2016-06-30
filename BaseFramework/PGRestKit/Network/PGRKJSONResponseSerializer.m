//
//  PGRKJSONResponseSerializer.m
//  Penguin
//
//  Created by Jing Dai on 6/30/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGRKJSONResponseSerializer.h"

@implementation PGRKJSONResponseSerializer

- (nullable id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing  _Nullable *)error
{
    id responseObject = [super responseObjectForResponse:response data:data error:error];
    
    if (responseObject) {
        
    }
    
    return responseObject;
}

@end
