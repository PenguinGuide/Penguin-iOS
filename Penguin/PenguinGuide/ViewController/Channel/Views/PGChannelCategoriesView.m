//
//  PGChannelCategoriesView.m
//  Penguin
//
//  Created by Jing Dai on 8/26/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define CategoryCell @"CategoryCell"

#import "PGChannelCategoriesView.h"
#import "PGChannelCategoryCell.h"

@interface PGChannelCategoriesView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *categoriesCollectionView;
@property (nonatomic, strong) NSArray *categoriesArray;
@property (nonatomic, assign) NSInteger currentSelectedIndex;

@end

@implementation PGChannelCategoriesView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.backgroundColor = Theme.colorBackground;
    
    [self addSubview:self.categoriesCollectionView];
}

- (void)reloadViewWithCategories:(NSArray *)categoriesArray
{
    self.categoriesArray = categoriesArray;
    
    [self.categoriesCollectionView reloadData];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.categoriesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGChannelCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CategoryCell forIndexPath:indexPath];
    
    id category = self.categoriesArray[indexPath.item];
    if ([category isKindOfClass:[PGChannelCategory class]]) {
        [cell setCellWithChannelCategory:category];
    } else {
        [cell setCellWithScenarioCategory:category];
    }
    
    if (indexPath.item == self.currentSelectedIndex) {
        [cell setSelected:YES];
    }
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 45+8);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 8, 0, 8);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGChannelCategoryCell *lastSelectedCell = (PGChannelCategoryCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentSelectedIndex inSection:0]];
    [lastSelectedCell setSelected:NO];
    
    self.currentSelectedIndex = indexPath.item;
    PGChannelCategoryCell *currentSelectedCell = (PGChannelCategoryCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [currentSelectedCell setSelected:YES];
    
    id category = self.categoriesArray[self.currentSelectedIndex];
    if ([category isKindOfClass:[PGChannelCategory class]]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(channelCategoryDidSelect:)]) {
            [self.delegate channelCategoryDidSelect:category];
        }
    } else if ([category isKindOfClass:[PGScenarioCategory class]]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(scenarioCategoryDidSelect:)]) {
            [self.delegate scenarioCategoryDidSelect:category];
        }
    }

}

- (UICollectionView *)categoriesCollectionView {
	if(_categoriesCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 5.f;
        layout.minimumInteritemSpacing = 0.f;
		_categoriesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 8, self.pg_width, self.pg_height-8) collectionViewLayout:layout];
        _categoriesCollectionView.dataSource = self;
        _categoriesCollectionView.delegate = self;
        _categoriesCollectionView.backgroundColor = Theme.colorBackground;
        _categoriesCollectionView.showsVerticalScrollIndicator = NO;
        _categoriesCollectionView.showsHorizontalScrollIndicator = NO;
        
        [_categoriesCollectionView registerClass:[PGChannelCategoryCell class] forCellWithReuseIdentifier:CategoryCell];
	}
	return _categoriesCollectionView;
}

@end
