//
//  XYRKNetworkLogger.h
//  Penguin
//
//  Created by Jing Dai on 6/30/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGRKNetworkLogger : NSObject

+ (PGRKNetworkLogger *)sharedInstance;

- (void)startLogging;
- (void)stopLogging;

@end
