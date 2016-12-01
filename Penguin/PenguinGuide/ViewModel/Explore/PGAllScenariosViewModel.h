//
//  PGAllScenariosViewModel.h
//  Penguin
//
//  Created by Jing Dai on 30/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewModel.h"

@interface PGAllScenariosViewModel : PGBaseViewModel

@property (nonatomic, strong, readonly) NSArray *scenariosArray;

- (void)requestScenarios:(NSString *)scenarioType;

@end
