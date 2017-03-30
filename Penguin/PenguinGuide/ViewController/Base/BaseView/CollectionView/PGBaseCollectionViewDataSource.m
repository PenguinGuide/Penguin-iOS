//
//  PGBaseCollectionViewDataSource.m
//  Penguin
//
//  Created by Kobe Dai on 06/03/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#define MoreCell @"MoreCell"

#import "PGBaseCollectionViewDataSource.h"
#import "PGImageCell.h"

@interface PGBaseCollectionViewDataSource ()

@property (nonatomic, strong) NSArray *models;
@property (nonatomic, strong) NSString *cellIdentifier;
@property (nonatomic, copy) ConfigureCellBlock configureCellBlock;
@property (nonatomic, assign) BOOL showMoreCell;
@property (nonatomic, weak) id<UICollectionViewDataSource> viewController;

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

+ (PGBaseCollectionViewDataSource *)dataSourceWithViewController:(id<UICollectionViewDataSource>)viewController cellIdentifier:(NSString *)cellIdentifier configureCellBlock:(ConfigureCellBlock)configureCellBlock
{
    PGBaseCollectionViewDataSource *dataSource = [[PGBaseCollectionViewDataSource alloc] init];
    
    dataSource.viewController = viewController;
    dataSource.cellIdentifier = cellIdentifier;
    dataSource.configureCellBlock = [configureCellBlock copy];
    
    return dataSource;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if ([self.viewController respondsToSelector:aSelector]) {
        return self.viewController;
    }
    return nil;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([super respondsToSelector:aSelector]) {
        return YES;
    } else {
        if ([self.viewController respondsToSelector:aSelector]) {
            return YES;
        }
    }
    return NO;
}

- (void)reloadModels:(NSArray *)models
{
    self.models = models;
}

- (void)reloadModels:(NSArray *)models showMoreCell:(BOOL)showMoreCell
{
    self.models = models;
    self.showMoreCell = showMoreCell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.showMoreCell?self.models.count+1:self.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == self.models.count) {
        PGImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MoreCell forIndexPath:indexPath];
        
        [cell setCellWithImage:[UIImage imageNamed:@"pg_store_more_scenarios"]];
        
        return cell;
    } else {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
        
        id model = self.models[indexPath.item];
        if (self.configureCellBlock) {
            self.configureCellBlock((id<PGBaseCollectionViewCell>)cell, model);
        }
        
        return cell;
    }
}

@end
