//
//  PGGlobalObject.h
//  Penguin
//
//  Created by Jing Dai on 7/11/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define PGGlobal [PGGlobalObject sharedInstance]

#import <Foundation/Foundation.h>
#import "PGBaseNavigationController.h"
#import "PGCache.h"

@interface PGGlobalObject : NSObject

+ (PGGlobalObject *)sharedInstance;

@property (nonatomic, strong) PGBaseNavigationController *rootNavigationController;
@property (nonatomic, strong) PGCache *cache;

@end
