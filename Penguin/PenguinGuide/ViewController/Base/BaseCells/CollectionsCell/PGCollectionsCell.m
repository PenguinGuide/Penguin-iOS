//
//  PGCollectionsCell.m
//  Penguin
//
//  Created by Kobe Dai on 16/03/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

static NSString *const CollectionCell = @"CollectionCell";
static NSString *const MoreCell = @"MoreCell";

#import "PGCollectionsCell.h"
#import "PGImageCell.h"

@implementation PGCollectionsCellConfig

@end

@interface PGCollectionsCell () <UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSAttributedString *title;
@property (nonatomic, strong) NSArray *collections;
@property (nonatomic, assign) Class CellClass;
@property (nonatomic, strong) PGCollectionsCellConfig *config;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionsCollectionView;
@property (nonatomic, strong) PGBaseCollectionViewDataSource *dataSource;
@property (nonatomic, strong) PGBaseCollectionViewDelegate *delegate;

@end

@implementation PGCollectionsCell

- (void)setCellWithTitle:(NSAttributedString *)title
             collections:(NSArray *)collections
               cellClass:(Class)CellClass
                  config:(PGCollectionsCellConfigBlock)configBlock
{
    PGCollectionsCellConfig *config = [[PGCollectionsCellConfig alloc] init];
    configBlock(config);
    
    self.title = title;
    self.collections = collections;
    self.CellClass = CellClass;
    self.config = config;
    
    if (self.collections) {
        if (!self.titleLabel.superview) {
            [self.contentView addSubview:self.titleLabel];
        }
        if (!self.collectionsCollectionView.superview) {
            [self.contentView addSubview:self.collectionsCollectionView];
        }
        
        [self.dataSource reloadModels:self.collections showMoreCell:(self.config.moreCellLink && self.config.moreCellLink.length > 0)];
        [self.collectionsCollectionView reloadData];
    }
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<PGBaseCollectionViewCell> selectedCell = (id<PGBaseCollectionViewCell>)[collectionView cellForItemAtIndexPath:indexPath];
    if ([selectedCell respondsToSelector:@selector(moreCellDidSelectWithLink:)]) {
        [selectedCell moreCellDidSelectWithLink:self.config.moreCellLink];
    } else if ([selectedCell respondsToSelector:@selector(cellDidSelectWithModel:)]) {
        [selectedCell cellDidSelectWithModel:self.collections[indexPath.item]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.config.showBorder) {
        if ([cell isKindOfClass:[PGBaseCollectionViewCell class]]) {
            [(PGBaseCollectionViewCell *)cell insertCellBorderLayer:8.f];
        }
    }
}

#pragma mark - <Lazy Init>

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, self.config.titleHeight)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.attributedText = self.title;
    }
    return _titleLabel;
}

- (UICollectionView *)collectionsCollectionView
{
    if (!_collectionsCollectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = self.config.minimumLineSpacing;
        layout.minimumInteritemSpacing = self.config.minimumInteritemSpacing;
        _collectionsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.config.titleHeight, self.pg_width, self.config.insets.top+self.config.collectionCellSize.height+self.config.insets.bottom) collectionViewLayout:layout];
        _collectionsCollectionView.backgroundColor = [UIColor whiteColor];
        _collectionsCollectionView.dataSource = self.dataSource;
        _collectionsCollectionView.delegate = self.delegate;
        _collectionsCollectionView.showsHorizontalScrollIndicator = NO;
        _collectionsCollectionView.showsVerticalScrollIndicator = NO;
        // NOTE: property alwaysBounceHorizontal is very important, fix uicollectionview in cell gesture conflicts issue
        _collectionsCollectionView.alwaysBounceHorizontal = YES;
        
        [_collectionsCollectionView registerClass:self.CellClass forCellWithReuseIdentifier:CollectionCell];
        if (self.config.moreCellLink && self.config.moreCellLink.length > 0) {
            [_collectionsCollectionView registerClass:[PGImageCell class] forCellWithReuseIdentifier:MoreCell];
        }
    }
    return _collectionsCollectionView;
}

- (PGBaseCollectionViewDataSource *)dataSource
{
    if (!_dataSource) {
        _dataSource = [PGBaseCollectionViewDataSource dataSourceWithCellIdentifier:CollectionCell
                                                                configureCellBlock:^(id<PGBaseCollectionViewCell> cell, PGRKModel *model) {
                                                                    if ([cell respondsToSelector:@selector(setCellWithModel:)]) {
                                                                        [cell setCellWithModel:model];
                                                                    }
                                                                }];
        [_dataSource reloadModels:self.collections showMoreCell:(self.config.moreCellLink && self.config.moreCellLink.length > 0)];
    }
    return _dataSource;
}

- (PGBaseCollectionViewDelegate *)delegate
{
    if (!_delegate) {
        _delegate = [PGBaseCollectionViewDelegate delegateWithViewController:self
                                                          minimumLineSpacing:self.config.minimumLineSpacing
                                                     minimumInteritemSpacing:self.config.minimumInteritemSpacing
                                                                      insets:self.config.insets
                                                                    cellSize:self.config.collectionCellSize];
    }
    return _delegate;
}

@end
