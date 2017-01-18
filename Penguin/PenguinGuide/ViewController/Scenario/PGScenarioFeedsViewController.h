//
//  PGScenarioFeedsViewController.h
//  Penguin
//
//  Created by Jing Dai on 02/12/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewController.h"
#import "PGScenarioDelegate.h"

@interface PGScenarioFeedsViewController : PGBaseViewController

@property (nonatomic, weak) id<PGScenarioDelegate> delegate;

- (id)initWithScenarioId:(NSString *)scenarioId;

@end
