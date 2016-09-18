//
//  PGRouterManager.h
//  Penguin
//
//  Created by Jing Dai on 7/11/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGRouter.h"

@interface PGRouterManager : NSObject

+ (void)registerRouters;

+ (void)routeToLoginPage;

+ (void)routeToTopicPage;

@end
