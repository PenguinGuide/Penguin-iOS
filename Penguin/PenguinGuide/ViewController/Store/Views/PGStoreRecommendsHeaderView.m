//
//  PGStoreRecommendsHeaderView.m
//  Penguin
//
//  Created by Jing Dai on 8/31/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define CategoryCell @"CategoryCell"

#import "PGStoreRecommendsHeaderView.h"
#import "PGCategoryCell.h"
#import "PGImageBanner.h"

#import "UIButton+WebCache.h"

@interface PGStoreRecommendsHeaderView () <PGPagedScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *recommendsArray;
@property (nonatomic, strong) NSArray *categoriesArray;
@property (nonatomic, strong) UICollectionView *categoriesCollectionView;
@property (nonatomic, strong, readwrite) PGPagedScrollView *bannersView;
@property (nonatomic, strong) UILabel *categoryLabel;

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
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.bannersView];
    [self addSubview:self.categoriesCollectionView];
    
//    UIView *horizontalLineView = [[UIView alloc] initWithFrame:CGRectMake(20, self.pg_height-1/[UIScreen mainScreen].scale, self.pg_width-40, 1/[UIScreen mainScreen].scale)];
//    horizontalLineView.backgroundColor = [UIColor colorWithHexString:@"F1F1F1"];
//    [self addSubview:horizontalLineView];
}

- (void)reloadBannersWithRecommendsArray:(NSArray *)recommendsArray categoriesArray:(NSArray *)categoriesArray
{
    if (!self.categoryLabel && categoriesArray.count > 0) {
        self.categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.bannersView.pg_bottom+15, 150, 20)];
        self.categoryLabel.font = Theme.fontExtraLargeBold;
        self.categoryLabel.textColor = Theme.colorText;
        self.categoryLabel.text = @"企 鹅 精 选";
        [self addSubview:self.categoryLabel];
    }
    self.recommendsArray = recommendsArray;
    self.categoriesArray = categoriesArray;
    [self.categoriesCollectionView reloadData];
    [self.bannersView reloadData];
}

+ (CGSize)headerViewSize
{
    return CGSizeMake(UISCREEN_WIDTH, UISCREEN_WIDTH*9/16+15+18+20+115+10);
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
    return self.categoriesArray.count == 0 ? 0 : 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.categoriesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CategoryCell forIndexPath:indexPath];
    
    PGCategoryIcon *icon = self.categoriesArray[indexPath.item];
    [cell setCellWithCategoryIcon:icon];
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [PGCategoryCell cellSize];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 20, 0, 20);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(categoryDidSelect:)]) {
        PGCategoryIcon *icon = self.categoriesArray[indexPath.item];
        [self.delegate categoryDidSelect:icon];
    }
}

#pragma mark - <Setters && Getters>

- (NSArray *)dataArray
{
    if (!_recommendsArray) {
        _recommendsArray = [NSArray new];
    }
    return _recommendsArray;
}

- (NSArray *)categoriesArray
{
    if (!_categoriesArray) {
        _categoriesArray = [NSArray new];
    }
    return _categoriesArray;
}

- (PGPagedScrollView *)bannersView
{
    if (!_bannersView) {
        _bannersView = [[PGPagedScrollView alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, UISCREEN_WIDTH*9/16) imageFillMode:PGPagedScrollViewImageFillModeFill iconMode:PGPagedScrollViewIconModeDefault];
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
        _categoriesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.bannersView.pg_bottom+15+18+20, self.pg_width, 115) collectionViewLayout:layout];
        _categoriesCollectionView.backgroundColor = [UIColor whiteColor];
        _categoriesCollectionView.showsVerticalScrollIndicator = NO;
        _categoriesCollectionView.showsHorizontalScrollIndicator = NO;
        _categoriesCollectionView.dataSource = self;
        _categoriesCollectionView.delegate = self;
        [_categoriesCollectionView registerClass:[PGCategoryCell class] forCellWithReuseIdentifier:CategoryCell];
    }
    return _categoriesCollectionView;
}

@end
