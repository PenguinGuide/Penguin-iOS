//
//  PGGlobalObject.h
//  Penguin
//
//  Created by Jing Dai on 7/11/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGBaseNavigationController.h"

@interface PGGlobalObject : NSObject

+ (PGGlobalObject *)sharedInstance;

@property (nonatomic, strong) PGBaseNavigationController *rootNavigationController;

@end
