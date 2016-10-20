//
//  PGGoodTagsCell.m
//  Penguin
//
//  Created by Jing Dai on 08/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define TagCell @"TagCell"

#import "PGGoodTagsCell.h"
#import "PGTagCell.h"
#import "PGTag.h"

@interface PGGoodTagsCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) PGBaseCollectionView *tagsCollectionView;
@property (nonatomic, strong) NSArray *tagsArray;

@end

@implementation PGGoodTagsCell

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
    [self.contentView addSubview:self.tagsCollectionView];
}

- (void)reloadWithTagsArray:(NSArray *)tagsArray
{
    self.tagsArray = tagsArray;
    
    [self.tagsCollectionView reloadData];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tagsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TagCell forIndexPath:indexPath];
    
    PGTag *tag = self.tagsArray[indexPath.item];
    [cell setCellWithTagName:tag.name];
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 38, 0, 38);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGTag *tag = self.tagsArray[indexPath.item];
    
    return [PGTagCell cellSize:tag.name];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (UICollectionView *)tagsCollectionView
{
    if (!_tagsCollectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _tagsCollectionView = [[PGBaseCollectionView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 20) collectionViewLayout:layout];
        _tagsCollectionView.dataSource = self;
        _tagsCollectionView.delegate = self;
        _tagsCollectionView.backgroundColor = [UIColor clearColor];
        
        [_tagsCollectionView registerClass:[PGTagCell class] forCellWithReuseIdentifier:TagCell];
    }
    return _tagsCollectionView;
}

@end
