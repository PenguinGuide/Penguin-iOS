//
//  PGScenarioFeedsViewModel.h
//  Penguin
//
//  Created by Jing Dai on 02/12/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewModel.h"

@interface PGScenarioFeedsViewModel : PGBaseViewModel

@property (nonatomic, strong, readonly) NSArray *feedsArray;

- (void)requestFeeds:(NSString *)scenarioId;

@end
