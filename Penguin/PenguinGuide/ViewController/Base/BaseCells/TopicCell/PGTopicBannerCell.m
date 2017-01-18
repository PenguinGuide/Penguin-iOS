//
//  PGTopicBannerCell.m
//  Penguin
//
//  Created by Jing Dai on 8/24/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

static NSString *const GoodCell = @"GoodCell";

#import "PGTopicBannerCell.h"
#import "PGTopicGoodCell.h"
#import "PGGood.h"

@interface PGTopicBannerCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIImageView *bannerImageView;
@property (nonatomic, strong) UICollectionView *goodsCollectionView;
@property (nonatomic, strong) NSArray *goodsArray;

@end

@implementation PGTopicBannerCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    
    return self;
}

- (void)initialize
{
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    
    [self.contentView addSubview:self.bannerImageView];
    [self.contentView addSubview:self.goodsCollectionView];
    
    CGFloat width = UISCREEN_WIDTH-40;
    UIImageView *maskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, width, width*9/16)];
    maskImageView.image = [[UIImage imageNamed:@"pg_bg_corner_mask"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4) resizingMode:UIImageResizingModeStretch];
    [self.contentView addSubview:maskImageView];
    
    UIImageView *indicatorView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bannerImageView.pg_width/2-7, self.bannerImageView.pg_height-10, 14, 10)];
    indicatorView.image = [UIImage imageNamed:@"pg_topic_indicator"];
    [self.bannerImageView addSubview:indicatorView];
    
}

- (void)setCellWithTopic:(PGTopicBanner *)topic
{
    [self.bannerImageView setWithImageURL:topic.image placeholder:nil completion:nil];
    self.goodsArray = topic.goodsArray;
    
    [self.goodsCollectionView reloadData];
}

+ (CGSize)cellSize
{
    CGFloat width = UISCREEN_WIDTH;
    return CGSizeMake(width, width*9/16+115);
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.goodsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGTopicGoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodCell forIndexPath:indexPath];
    
    PGGood *good = self.goodsArray[indexPath.item];
    [cell setCellWithGood:good];
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 20, 0, 20);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(120, 120*2/3+5+14+3+16);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGGood *good = self.goodsArray[indexPath.item];
    [PGRouterManager routeToGoodDetailPage:good.goodId link:good.link];
}

#pragma mark - <Setters && Getters>

- (UIImageView *)bannerImageView {
	if(_bannerImageView == nil) {
        CGFloat width = UISCREEN_WIDTH-40;
		_bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, width, width*9/16)];
        _bannerImageView.backgroundColor = Theme.colorBackground;
        _bannerImageView.clipsToBounds = YES;
        _bannerImageView.contentMode = UIViewContentModeScaleAspectFill;
	}
	return _bannerImageView;
}

- (UICollectionView *)goodsCollectionView {
	if(_goodsCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0.f;
        layout.minimumLineSpacing = 10.f;
        _goodsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.bannerImageView.pg_bottom+10, UISCREEN_WIDTH, 120*2/3+5+14+3+16) collectionViewLayout:layout];
        _goodsCollectionView.dataSource = self;
        _goodsCollectionView.delegate = self;
        _goodsCollectionView.showsVerticalScrollIndicator = NO;
        _goodsCollectionView.showsHorizontalScrollIndicator = NO;
        _goodsCollectionView.backgroundColor = [UIColor whiteColor];
        
        [_goodsCollectionView registerClass:[PGTopicGoodCell class] forCellWithReuseIdentifier:GoodCell];
	}
	return _goodsCollectionView;
}

@end
