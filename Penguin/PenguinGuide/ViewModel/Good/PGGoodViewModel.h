//
//  PGGoodViewModel.h
//  Penguin
//
//  Created by Jing Dai on 28/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewModel.h"
#import "PGGood.h"

@interface PGGoodViewModel : PGBaseViewModel

@property (nonatomic, strong, readonly) PGGood *good;
@property (nonatomic, strong, readonly) NSArray *relatedGoods;

- (void)requestGood:(NSString *)goodId;
- (void)requestRelatedGoods;

@end
