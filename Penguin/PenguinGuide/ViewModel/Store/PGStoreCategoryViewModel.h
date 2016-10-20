//
//  PGStoreCategoryViewModel.h
//  Penguin
//
//  Created by Jing Dai on 9/1/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewModel.h"
#import "PGGood.h"

@interface PGStoreCategoryViewModel : PGBaseViewModel

@property (nonatomic, strong, readonly) NSArray *goodsArray;

@end
