//
//  PGScenarioGoodsViewModel.h
//  Penguin
//
//  Created by Jing Dai on 02/12/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewModel.h"
#import "PGGood.h"

@interface PGScenarioGoodsViewModel : PGBaseViewModel

@property (nonatomic, strong, readonly) NSArray *goodsArray;

- (void)requestGoods:(NSString *)scenarioId;

@end
