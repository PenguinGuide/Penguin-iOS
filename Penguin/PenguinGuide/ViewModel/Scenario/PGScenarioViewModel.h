//
//  PGScenarioViewModel.h
//  Penguin
//
//  Created by Jing Dai on 8/31/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewModel.h"
#import "PGScenario.h"

@interface PGScenarioViewModel : PGBaseViewModel

@property (nonatomic, strong, readonly) PGScenario *scenario;
@property (nonatomic, strong, readonly) NSArray *feedsArray;

- (void)requestScenario:(NSString *)scenarioId;

@end
