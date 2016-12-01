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

+ (void)routeToHomePage;

+ (void)routeToScenarioPage:(NSString *)scenarioId link:(NSString *)link;
+ (void)routeToArticlePage:(NSString *)articleId link:(NSString *)link;
+ (void)routeToGoodDetailPage:(NSString *)goodId link:(NSString *)link;
+ (void)routeToAllScenariosPage:(NSString *)scenarioType;

@end
