//
//  PGGoodsCollectionBannerCell.m
//  Penguin
//
//  Created by Jing Dai on 8/24/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

static NSString *const GoodCell = @"GoodCell";

#import "PGGoodsCollectionBannerCell.h"
#import "PGGoodsCollectionGoodCell.h"

@interface PGGoodsCollectionBannerCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *goodsCollectionView;

@property (nonatomic, strong) NSArray *goodsArray;

@end

@implementation PGGoodsCollectionBannerCell

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
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.descLabel];
    [self.contentView addSubview:self.goodsCollectionView];
}

- (void)setCellWithModel:(PGRKModel *)model
{
    if ([model isKindOfClass:[PGGoodsCollectionBanner class]]) {
        PGGoodsCollectionBanner *goodsCollection = (PGGoodsCollectionBanner *)model;
        self.titleLabel.text = goodsCollection.title;
        self.descLabel.text = goodsCollection.desc;
        self.goodsArray = goodsCollection.goodsArray;
        
        [self.goodsCollectionView reloadData];
    }
}

- (void)setCellWithGoodsCollection:(PGGoodsCollectionBanner *)goodsCollection
{
    self.titleLabel.text = goodsCollection.title;
    self.descLabel.text = goodsCollection.desc;
    self.goodsArray = goodsCollection.goodsArray;
    
    [self.goodsCollectionView reloadData];
}

+ (CGSize)cellSize
{
    return CGSizeMake(UISCREEN_WIDTH, 275);
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
    PGGoodsCollectionGoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodCell forIndexPath:indexPath];
    
    PGGood *good = self.goodsArray[indexPath.item];
    cell.eventName = goods_collection_good_clicked;
    cell.eventId = good.goodId;
    cell.pageName = self.pageName;
    
    [cell setCellWithGood:good];
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 22, 0, 22);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(150, 210);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGGood *good = self.goodsArray[indexPath.item];
    [[PGRouter sharedInstance] openURL:good.link];
}

#pragma mark - <Setters && Getters>

- (UILabel *)titleLabel {
	if(_titleLabel == nil) {
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 8, UISCREEN_WIDTH-40, 20)];
        _titleLabel.font = Theme.fontLargeBold;
        _titleLabel.textColor = Theme.colorLightText;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _titleLabel;
}

- (UILabel *)descLabel {
	if(_descLabel == nil) {
		_descLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.titleLabel.pg_bottom+7, UISCREEN_WIDTH-40, 15)];
        _descLabel.font = Theme.fontSmallLight;
        _descLabel.textColor = Theme.colorLightText;
        _descLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _descLabel;
}

- (UICollectionView *)goodsCollectionView {
	if(_goodsCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0.f;
        layout.minimumLineSpacing = 10.f;
		_goodsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50+15, UISCREEN_WIDTH, 210) collectionViewLayout:layout];
        _goodsCollectionView.dataSource = self;
        _goodsCollectionView.delegate = self;
        _goodsCollectionView.showsVerticalScrollIndicator = NO;
        _goodsCollectionView.showsHorizontalScrollIndicator = NO;
        _goodsCollectionView.backgroundColor = [UIColor whiteColor];
        
        [_goodsCollectionView registerClass:[PGGoodsCollectionGoodCell class] forCellWithReuseIdentifier:GoodCell];
	}
	return _goodsCollectionView;
}

@end
