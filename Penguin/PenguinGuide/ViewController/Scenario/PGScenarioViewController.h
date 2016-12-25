//
//  PGScenarioViewController.h
//  Penguin
//
//  Created by Jing Dai on 8/30/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewController.h"

@interface PGScenarioViewController : PGBaseViewController

@property (nonatomic, assign) BOOL isFromStorePage;

- (id)initWithScenarioId:(NSString *)scenarioId;

@end
