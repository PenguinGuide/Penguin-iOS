//
//  PGScenarioCell.m
//  Penguin
//
//  Created by Jing Dai on 29/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define CategoryCell @"CategoryCell"

#import "PGScenarioCell.h"
#import "PGCategoryCell.h"
#import "PGScenarioBanner.h"

@interface PGScenarioCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *bannersCollectionView;

@property (nonatomic, strong) NSArray *banners;
@property (nonatomic, strong) NSString *scenarioType;

@end

@implementation PGScenarioCell

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
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.bannersCollectionView];
    
    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(UISCREEN_WIDTH-100-15, 22.5, 100, 20)];
    [moreButton setTitle:@"查 看 更 多" forState:UIControlStateNormal];
    [moreButton setTitleColor:Theme.colorLightText forState:UIControlStateNormal];
    [moreButton.titleLabel setFont:Theme.fontSmallBold];
    [moreButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [moreButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self.contentView addSubview:moreButton];
    [moreButton addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)reloadWithBanners:(NSArray *)banners title:(NSString *)title scenarioType:(NSString *)scenarioType
{
    self.titleLabel.text = title;
    self.banners = banners;
    self.scenarioType = scenarioType;
    
    [self.bannersCollectionView reloadData];
}

+ (CGSize)cellSize
{
    return CGSizeMake(UISCREEN_WIDTH, 65+115+10);
}

- (void)moreButtonClicked
{
    [PGRouterManager routeToAllScenariosPage:self.scenarioType];
}

#pragma mark - <UICollectionView>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.banners.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CategoryCell forIndexPath:indexPath];
    
    PGScenarioBanner *icon = self.banners[indexPath.item];
    [cell setCellWithCategoryIcon:icon];
    
    return cell;
}

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
    PGScenarioBanner *scenarioBanner = self.banners[indexPath.item];
    [PGRouterManager routeToScenarioPage:scenarioBanner.scenarioId link:scenarioBanner.link];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 22.5, 200, 20)];
        _titleLabel.font = Theme.fontExtraLargeBold;
        _titleLabel.textColor = Theme.colorText;
    }
    return _titleLabel;
}

- (UICollectionView *)bannersCollectionView
{
    if (!_bannersCollectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 15.f;
        layout.minimumInteritemSpacing = 0.f;
        _bannersCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 65, self.pg_width, 115) collectionViewLayout:layout];
        _bannersCollectionView.backgroundColor = [UIColor whiteColor];
        _bannersCollectionView.showsVerticalScrollIndicator = NO;
        _bannersCollectionView.showsHorizontalScrollIndicator = NO;
        _bannersCollectionView.dataSource = self;
        _bannersCollectionView.delegate = self;
        [_bannersCollectionView registerClass:[PGCategoryCell class] forCellWithReuseIdentifier:CategoryCell];
    }
    return _bannersCollectionView;
}

@end
