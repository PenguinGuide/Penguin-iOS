//
//  PGStoreRecommendsHeaderView.m
//  Penguin
//
//  Created by Jing Dai on 8/31/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define ChannelCell @"ChannelCell"

#import "PGStoreRecommendsHeaderView.h"
#import "PGHomeChannelCell.h"
#import "PGImageBanner.h"

#import "UIButton+WebCache.h"

@interface PGStoreRecommendsHeaderView () <PGPagedScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *categoriesArray;
@property (nonatomic, strong) UICollectionView *categoriesCollectionView;
@property (nonatomic, strong, readwrite) PGPagedScrollView *bannersView;

@end

@implementation PGStoreRecommendsHeaderView

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
    
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(13, self.bannersView.pg_bottom+10, 3, 16)];
    verticalLine.backgroundColor = Theme.colorExtraHighlight;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(verticalLine.pg_right+5, self.bannersView.pg_bottom+10, 100, 16)];
    label.font = Theme.fontMediumBold;
    label.textColor = Theme.colorText;
    label.text = @"品类";
    [self addSubview:verticalLine];
    [self addSubview:label];
    
    [self addSubview:self.categoriesCollectionView];
}

- (void)reloadBannersWithData:(NSArray *)dataArray categoriesArray:(NSArray *)categoriesArray
{
    self.dataArray = dataArray;
    self.categoriesArray = categoriesArray;
    [self.categoriesCollectionView reloadData];
    [self.bannersView reloadData];
}

+ (CGSize)headerViewSize
{
    return CGSizeMake(UISCREEN_WIDTH, UISCREEN_WIDTH*160/320+10+16+80);
}

- (void)imageViewDidSelect:(NSInteger)index
{
    PGImageBanner *banner = self.dataArray[index];
    [[PGRouter sharedInstance] openURL:banner.link];
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
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGHomeChannelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ChannelCell forIndexPath:indexPath];
    
    if (indexPath.item == 0) {
        [cell.channelButton setImage:[UIImage imageNamed:@"pg_store_category_beer"] forState:UIControlStateNormal];
        [cell.channelLabel setText:@"精酿啤酒"];
    } else if (indexPath.item == 1) {
        [cell.channelButton setImage:[UIImage imageNamed:@"pg_store_category_wine"] forState:UIControlStateNormal];
        [cell.channelLabel setText:@"葡萄酒"];
    } else if (indexPath.item == 2) {
        [cell.channelButton setImage:[UIImage imageNamed:@"pg_store_category_tea"] forState:UIControlStateNormal];
        [cell.channelLabel setText:@"茶"];
    } else if (indexPath.item == 3) {
        [cell.channelButton setImage:[UIImage imageNamed:@"pg_store_category_coffee"] forState:UIControlStateNormal];
        [cell.channelLabel setText:@"咖啡"];
    } else if (indexPath.item == 4) {
        [cell.channelButton setImage:[UIImage imageNamed:@"pg_store_category_food"] forState:UIControlStateNormal];
        [cell.channelLabel setText:@"食品"];
    } else if (indexPath.item == 5) {
        [cell.channelButton setImage:[UIImage imageNamed:@"pg_store_category_tool"] forState:UIControlStateNormal];
        [cell.channelLabel setText:@"器具"];
    } else {
        [cell.channelButton setImage:[UIImage imageNamed:@"pg_store_category_kitchen"] forState:UIControlStateNormal];
        [cell.channelLabel setText:@"厨房"];
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(categoryDidSelect:)]) {
        [self.delegate categoryDidSelect:nil];
    }
//    if (indexPath.item == 0) {
//        if (self.delegate && [self.delegate respondsToSelector:@selector(channelDidSelect:)]) {
//            [self.delegate channelDidSelect:@"111"];
//        }
//    } else if (indexPath.item == 1) {
//        if (self.delegate && [self.delegate respondsToSelector:@selector(channelDidSelect:)]) {
//            [self.delegate channelDidSelect:@"111"];
//        }
//    } else if (indexPath.item == 2) {
//        if (self.delegate && [self.delegate respondsToSelector:@selector(channelDidSelect:)]) {
//            [self.delegate channelDidSelect:@"111"];
//        }
//    } else if (indexPath.item == 3) {
//        if (self.delegate && [self.delegate respondsToSelector:@selector(channelDidSelect:)]) {
//            [self.delegate channelDidSelect:@"111"];
//        }
//    } else if (indexPath.item == 4) {
//        if (self.delegate && [self.delegate respondsToSelector:@selector(channelDidSelect:)]) {
//            [self.delegate channelDidSelect:@"111"];
//        }
//    }
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
        _bannersView = [[PGPagedScrollView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_WIDTH*160/320) imageFillMode:PGPagedScrollViewImageFillModeFill iconMode:PGPagedScrollViewIconModeDefault];
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
        _categoriesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.bannersView.pg_bottom+10+16, self.pg_width, 80) collectionViewLayout:layout];
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
