//
//  PGRouter.h
//  Penguin
//
//  Created by Jing Dai on 6/28/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

typedef void(^PGRouterHandler)(NSDictionary *params);

#import <Foundation/Foundation.h>

@interface PGRouter : NSObject

+ (PGRouter *)sharedInstance;

- (void)registerRoute:(NSString *)route toHandler:(PGRouterHandler)handler;
- (void)openURL:(NSString *)route;

@end
