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
#import "PGScenarioBanner.h"
#import "UIButton+WebCache.h"

@interface PGHomeRecommendsHeaderView () <PGPagedScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *recommendsArray;
@property (nonatomic, strong) NSArray *channelsArray;
@property (nonatomic, strong) UICollectionView *categoriesCollectionView;
@property (nonatomic, strong, readwrite) PGPagedScrollView *bannersView;
@property (nonatomic, strong) UIView *verticalLine;
@property (nonatomic, strong) UILabel *articleLabel;

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
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.bannersView];
    [self addSubview:self.categoriesCollectionView];
}

- (void)reloadBannersWithRecommendsArray:(NSArray *)recommendsArray channelsArray:(NSArray *)channelsArray
{
    if (!self.articleLabel && channelsArray.count > 0) {
        self.verticalLine = [[UIView alloc] initWithFrame:CGRectMake(13, self.bannersView.pg_bottom+11, 3, 16)];
        self.verticalLine.backgroundColor = Theme.colorExtraHighlight;
        self.articleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.verticalLine.pg_right+5, self.bannersView.pg_bottom+11, 100, 16)];
        self.articleLabel.font = Theme.fontMediumBold;
        self.articleLabel.textColor = Theme.colorText;
        self.articleLabel.text = @"文章";
        [self addSubview:self.verticalLine];
        [self addSubview:self.articleLabel];
    }
    self.recommendsArray = recommendsArray;
    self.channelsArray = channelsArray;
    [self.bannersView reloadData];
    [self.categoriesCollectionView reloadData];
}

+ (CGSize)headerViewSize
{
    return CGSizeMake(UISCREEN_WIDTH, UISCREEN_WIDTH*9/16+80+11+16);
}

#pragma mark - <PGPagedScrollViewDelegate>

- (NSArray *)imagesForScrollView
{
    NSMutableArray *banners = [NSMutableArray new];
    for (PGImageBanner *banner in self.recommendsArray) {
        if (banner.image) {
            [banners addObject:banner.image];
        }
    }
    return [NSArray arrayWithArray:banners];
}

- (void)imageViewDidSelect:(NSInteger)index
{
    PGImageBanner *banner = self.recommendsArray[index];
    [[PGRouter sharedInstance] openURL:banner.link];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.channelsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGHomeChannelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ChannelCell forIndexPath:indexPath];
    
    PGScenarioBanner *icon = self.channelsArray[indexPath.item];
    
    [cell.channelButton sd_setImageWithURL:[NSURL URLWithString:icon.image] forState:UIControlStateNormal placeholderImage:nil];
    [cell.channelLabel setText:icon.title];
    
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(channelDidSelect:)]) {
        PGScenarioBanner *icon = self.channelsArray[indexPath.item];
        [self.delegate channelDidSelect:icon.link];
    }
}

#pragma mark - <Setters && Getters>

- (NSArray *)recommendsArray
{
    if (!_recommendsArray) {
        _recommendsArray = [NSArray new];
    }
    return _recommendsArray;
}

- (NSArray *)channelsArray
{
    if (!_channelsArray) {
        _channelsArray = [NSArray new];
    }
    return _channelsArray;
}

- (PGPagedScrollView *)bannersView
{
    if (!_bannersView) {
        _bannersView = [[PGPagedScrollView alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, self.pg_height-80-11-16) imageFillMode:PGPagedScrollViewImageFillModeFill iconMode:PGPagedScrollViewIconModeDefault];
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
        _categoriesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.bannersView.pg_bottom+11+16, self.pg_width, 80) collectionViewLayout:layout];
        _categoriesCollectionView.backgroundColor = [UIColor whiteColor];
        _categoriesCollectionView.showsVerticalScrollIndicator = NO;
        _categoriesCollectionView.showsHorizontalScrollIndicator = NO;
        _categoriesCollectionView.dataSource = self;
        _categoriesCollectionView.delegate = self;
        [_categoriesCollectionView registerClass:[PGHomeChannelCell class] forCellWithReuseIdentifier:ChannelCell];
    }
    return _categoriesCollectionView;
}

@end
