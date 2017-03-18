//
//  PGBaseCollectionViewDataSource.m
//  Penguin
//
//  Created by Kobe Dai on 06/03/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import "PGBaseCollectionViewDataSource.h"

@interface PGBaseCollectionViewDataSource ()

@property (nonatomic, strong) NSArray *models;
@property (nonatomic, strong) NSString *cellIdentifier;
@property (nonatomic, copy) ConfigureCellBlock configureCellBlock;

@end

@implementation PGBaseCollectionViewDataSource

+ (PGBaseCollectionViewDataSource *)dataSourceWithCellIdentifier:(NSString *)cellIdentifier
                                              configureCellBlock:(void (^)(id<PGBaseCollectionViewCell> cell, PGRKModel *model))configureCellBlock
{
    PGBaseCollectionViewDataSource *dataSource = [[PGBaseCollectionViewDataSource alloc] init];
    
    dataSource.cellIdentifier = cellIdentifier;
    dataSource.configureCellBlock = [configureCellBlock copy];
    
    return dataSource;
}

- (void)reloadModels:(NSArray *)models
{
    self.models = models;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    
    id model = self.models[indexPath.item];
    if (self.configureCellBlock) {
        self.configureCellBlock((id<PGBaseCollectionViewCell>)cell, model);
    }
    
    return cell;
}

@end
