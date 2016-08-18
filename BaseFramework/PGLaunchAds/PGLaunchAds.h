//
//  PGLaunchAds.h
//  Penguin
//
//  Created by Jing Dai on 8/10/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGLaunchAds : NSObject

+ (PGLaunchAds *)sharedInstance;

- (void)showAds;
- (void)hideAds;

@end
