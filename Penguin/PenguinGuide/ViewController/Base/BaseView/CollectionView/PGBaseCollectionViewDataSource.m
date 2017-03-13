//
//  PGBaseCollectionViewDataSource.m
//  Penguin
//
//  Created by Kobe Dai on 06/03/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import "PGBaseCollectionViewDataSource.h"

@interface PGBaseCollectionViewDataSource ()

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSString *cellIdentifier;
@property (nonatomic, copy) ConfigureCellBlock configureCellBlock;

@end

@implementation PGBaseCollectionViewDataSource

+ (PGBaseCollectionViewDataSource *)dataSourceWithCellIdentifier:(NSString *)cellIdentifier
                                              configureCellBlock:(void (^)(UICollectionViewCell *cell, id item))configureCellBlock
{
    PGBaseCollectionViewDataSource *dataSource = [[PGBaseCollectionViewDataSource alloc] init];
    
    dataSource.cellIdentifier = cellIdentifier;
    dataSource.configureCellBlock = [configureCellBlock copy];
    
    return dataSource;
}

- (void)reloadItems:(NSArray *)items
{
    self.items = items;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    
    id item = self.items[indexPath.item];
    if (self.configureCellBlock) {
        self.configureCellBlock(cell, item);
    }
    
    return cell;
}

@end
