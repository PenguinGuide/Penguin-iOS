//
//  PGSearchResultsGoodsViewModel.h
//  Penguin
//
//  Created by Kobe Dai on 15/12/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewModel.h"
#import "PGGood.h"

@interface PGSearchResultsGoodsViewModel : PGBaseViewModel

@property (nonatomic, strong, readonly) NSArray *goodsArray;

- (void)requestGoods:(NSString *)keyword;

@end
