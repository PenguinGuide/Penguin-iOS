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
    
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(13, 10, 3, 30)];
    verticalLine.backgroundColor = Theme.colorExtraHighlight;
    [self.contentView addSubview:verticalLine];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.descLabel];
    [self.contentView addSubview:self.goodsCollectionView];
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
    return CGSizeMake(UISCREEN_WIDTH, 285);
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
    [cell setCellWithGood:good];
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(160, 220);
}

#pragma mark - <Setters && Getters>

- (UILabel *)titleLabel {
	if(_titleLabel == nil) {
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 10, UISCREEN_WIDTH-25, 16)];
        _titleLabel.font = Theme.fontMediumBold;
        _titleLabel.textColor = Theme.colorText;
	}
	return _titleLabel;
}

- (UILabel *)descLabel {
	if(_descLabel == nil) {
		_descLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, self.titleLabel.bottom+3, UISCREEN_WIDTH-25, 12)];
        _descLabel.font = Theme.fontExtraSmallBold;
        _descLabel.textColor = Theme.colorLightText;
	}
	return _descLabel;
}

- (UICollectionView *)goodsCollectionView {
	if(_goodsCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0.f;
        layout.minimumLineSpacing = 10.f;
		_goodsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 55, UISCREEN_WIDTH, 220) collectionViewLayout:layout];
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