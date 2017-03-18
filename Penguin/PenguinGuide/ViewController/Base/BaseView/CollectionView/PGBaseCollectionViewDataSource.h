//
//  PGBaseCollectionViewDataSource.h
//  Penguin
//
//  Created by Kobe Dai on 06/03/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGBaseCollectionViewCell.h"

typedef void (^ConfigureCellBlock) (id<PGBaseCollectionViewCell> cell, PGRKModel *model);

@interface PGBaseCollectionViewDataSource : NSObject <UICollectionViewDataSource>

+ (PGBaseCollectionViewDataSource *)dataSourceWithCellIdentifier:(NSString *)cellIdentifier
                                              configureCellBlock:(ConfigureCellBlock)configureCellBlock;

- (void)reloadModels:(NSArray *)models;

@end
