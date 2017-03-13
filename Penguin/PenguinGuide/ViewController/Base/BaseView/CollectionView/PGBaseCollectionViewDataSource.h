//
//  PGBaseCollectionViewDataSource.h
//  Penguin
//
//  Created by Kobe Dai on 06/03/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

typedef void (^ConfigureCellBlock) (UICollectionViewCell *cell, id item);

#import <Foundation/Foundation.h>

@interface PGBaseCollectionViewDataSource : NSObject <UICollectionViewDataSource>

+ (PGBaseCollectionViewDataSource *)dataSourceWithCellIdentifier:(NSString *)cellIdentifier
                                              configureCellBlock:(ConfigureCellBlock)configureCellBlock;

- (void)reloadItems:(NSArray *)items;

@end
