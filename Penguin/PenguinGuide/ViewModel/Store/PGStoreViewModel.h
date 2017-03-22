//
//  PGStoreViewModel.h
//  Penguin
//
//  Created by Jing Dai on 8/31/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewModel.h"

@interface PGStoreViewModel : PGBaseViewModel

@property (nonatomic, strong, readonly) NSArray *scenariosArray;
@property (nonatomic, strong, readonly) NSArray *salesArray;
@property (nonatomic, strong, readonly) NSArray *collectionsArray;
@property (nonatomic, strong, readonly) NSArray *goodsArray;

- (void)requestGoods;

@end
