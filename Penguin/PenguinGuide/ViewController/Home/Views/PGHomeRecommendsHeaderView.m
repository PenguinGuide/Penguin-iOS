//
//  PGHomeArticleHeaderView.m
//  Penguin
//
//  Created by Jing Dai on 7/12/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

static NSString *const ChannelCell = @"ChannelCell";

#import "PGHomeRecommendsHeaderView.h"
#import "PGHomeChannelCell.h"
#import "PGImageBanner.h"

@interface PGHomeRecommendsHeaderView () <PGPagedScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UICollectionView *categoriesCollectionView;
@property (nonatomic, strong, readwrite) PGPagedScrollView *bannersView;

@end

@implementation PGHomeRecommendsHeaderView

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
    [self addSubview:self.bannersView];
    [self addSubview:self.categoriesCollectionView];
}

- (void)reloadBannersWithData:(NSArray *)dataArray
{
    self.dataArray = dataArray;
    [self.bannersView reloadData];
}

+ (CGSize)headerViewSize
{
    return CGSizeMake(UISCREEN_WIDTH, UISCREEN_WIDTH*160/320+80);
}

#pragma mark - <PGPagedScrollViewDelegate>

- (NSArray *)imagesForScrollView
{
    NSMutableArray *banners = [NSMutableArray new];
    for (PGImageBanner *banner in self.dataArray) {
        if (banner.image) {
            [banners addObject:banner.image];
        }
    }
    return [NSArray arrayWithArray:banners];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGHomeChannelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ChannelCell forIndexPath:indexPath];
    
    if (indexPath.item == 0) {
        [cell.channelButton setImage:[UIImage imageNamed:@"pg_home_category_wiki"] forState:UIControlStateNormal];
        [cell.channelLabel setText:@"涨知识"];
    } else if (indexPath.item == 1) {
        [cell.channelButton setImage:[UIImage imageNamed:@"pg_home_category_test"] forState:UIControlStateNormal];
        [cell.channelLabel setText:@"爱测评"];
    } else if (indexPath.item == 2) {
        [cell.channelButton setImage:[UIImage imageNamed:@"pg_home_category_store"] forState:UIControlStateNormal];
        [cell.channelLabel setText:@"企鹅市集"];
    } else if (indexPath.item == 3) {
        [cell.channelButton setImage:[UIImage imageNamed:@"pg_home_category_city_guide"] forState:UIControlStateNormal];
        [cell.channelLabel setText:@"城市指南"];
    } else if (indexPath.item == 4) {
        [cell.channelButton setImage:[UIImage imageNamed:@"pg_home_category_video"] forState:UIControlStateNormal];
        [cell.channelLabel setText:@"教你做"];
    }
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, 80);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(channelDidSelect:)]) {
            [self.delegate channelDidSelect:@"111"];
        }
    } else if (indexPath.item == 1) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(channelDidSelect:)]) {
            [self.delegate channelDidSelect:@"111"];
        }
    } else if (indexPath.item == 2) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(channelDidSelect:)]) {
            [self.delegate channelDidSelect:@"111"];
        }
    } else if (indexPath.item == 3) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(channelDidSelect:)]) {
            [self.delegate channelDidSelect:@"111"];
        }
    } else if (indexPath.item == 4) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(channelDidSelect:)]) {
            [self.delegate channelDidSelect:@"111"];
        }
    }
}

#pragma mark - <Setters && Getters>

- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSArray new];
    }
    return _dataArray;
}

- (PGPagedScrollView *)bannersView
{
    if (!_bannersView) {
        _bannersView = [[PGPagedScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height-80) imageFillMode:PGPagedScrollViewImageFillModeFill iconMode:PGPagedScrollViewIconModeDefault];
        _bannersView.delegate = self;
    }
    return _bannersView;
}

- (UICollectionView *)categoriesCollectionView
{
    if (!_categoriesCollectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 15.f;
        layout.minimumInteritemSpacing = 0.f;
        _categoriesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.bannersView.bottom, self.width, 80) collectionViewLayout:layout];
        _categoriesCollectionView.backgroundColor = Theme.colorBackground;
        _categoriesCollectionView.showsVerticalScrollIndicator = NO;
        _categoriesCollectionView.showsHorizontalScrollIndicator = NO;
        _categoriesCollectionView.dataSource = self;
        _categoriesCollectionView.delegate = self;
        [_categoriesCollectionView registerClass:[PGHomeChannelCell class] forCellWithReuseIdentifier:ChannelCell];
    }
    return _categoriesCollectionView;
}

@end
