//
//  PGSearchResultsGoodsViewController.h
//  Penguin
//
//  Created by Kobe Dai on 15/12/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewController.h"

@interface PGSearchResultsGoodsViewController : PGBaseViewController

- (id)initWithKeyword:(NSString *)keyword;

- (void)reloadWithKeyword:(NSString *)keyword;

@end
