//
//  PGFeedsCollectionView.m
//  Penguin
//
//  Created by Jing Dai on 8/29/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define CarouselBannerCell @"CarouselBannerCell"
#define ArticleBannerCell @"ArticleBannerCell"
#define GoodsCollectionBannerCell @"GoodsCollectionBannerCell"
#define TopicBannerCell @"TopicBannerCell"
#define SingleGoodBannerCell @"SingleGoodBannerCell"
#define FlashbuyBannerCell @"FlashbuyBannerCell"

#define HomeHeaderView @"HomeHeaderView"
#define ExploreHeaderView @"ExploreHeaderView"
#define StoreHeaderView @"StoreHeaderView"

#import "PGFeedsCollectionView.h"
#import "PGHomeRecommendsHeaderView.h"
#import "PGExploreRecommendsHeaderView.h"
#import "PGStoreRecommendsHeaderView.h"

@interface PGFeedsCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PGExploreRecommendsHeaderViewDelegate, PGHomeRecommendsHeaderViewDelegate, PGStoreRecommendsHeaderViewDelegate>

@end

@implementation PGFeedsCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = Theme.colorBackground;
        
        [self registerClass:[PGCarouselBannerCell class] forCellWithReuseIdentifier:CarouselBannerCell];
        [self registerClass:[PGArticleBannerCell class] forCellWithReuseIdentifier:ArticleBannerCell];
        [self registerClass:[PGGoodsCollectionBannerCell class] forCellWithReuseIdentifier:GoodsCollectionBannerCell];
        [self registerClass:[PGTopicBannerCell class] forCellWithReuseIdentifier:TopicBannerCell];
        [self registerClass:[PGSingleGoodBannerCell class] forCellWithReuseIdentifier:SingleGoodBannerCell];
        [self registerClass:[PGFlashbuyBannerCell class] forCellWithReuseIdentifier:FlashbuyBannerCell];
        
        [self registerClass:[PGHomeRecommendsHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomeHeaderView];
        [self registerClass:[PGExploreRecommendsHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ExploreHeaderView];
        [self registerClass:[PGStoreRecommendsHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:StoreHeaderView];
    }
    return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    // FIXME: if feedsArray is empty, header view will not show up
    if (self.feedsDelegate && [self.feedsDelegate respondsToSelector:@selector(feedsArray)]) {
        return [self.feedsDelegate feedsArray].count;
    } else {
        return 0;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.feedsDelegate && [self.feedsDelegate respondsToSelector:@selector(feedsArray)]) {
        NSArray *feedsArray = [self.feedsDelegate feedsArray];
        
        id banner = feedsArray[section];
        if ([banner isKindOfClass:[PGCarouselBanner class]]) {
            return 1;
        } else if ([banner isKindOfClass:[PGArticleBanner class]]) {
            return 1;
        } else if ([banner isKindOfClass:[PGGoodsCollectionBanner class]]) {
            return 1;
        } else if ([banner isKindOfClass:[PGTopicBanner class]]) {
            return 1;
        } else if ([banner isKindOfClass:[PGSingleGoodBanner class]]) {
            return 1;
        } else if ([banner isKindOfClass:[PGFlashbuyBanner class]]) {
            return 1;
        }
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.feedsDelegate && [self.feedsDelegate respondsToSelector:@selector(feedsArray)]) {
        NSArray *feedsArray = [self.feedsDelegate feedsArray];
        
        id banner = feedsArray[indexPath.section];
        
        if ([banner isKindOfClass:[PGCarouselBanner class]]) {
            PGCarouselBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CarouselBannerCell forIndexPath:indexPath];
            
            PGCarouselBanner *carouselBanner = (PGCarouselBanner *)banner;
            [cell reloadBannersWithData:carouselBanner.banners];
            
            return cell;
        } else if ([banner isKindOfClass:[PGArticleBanner class]]) {
            PGArticleBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleBannerCell forIndexPath:indexPath];
            
            PGArticleBanner *articleBanner = (PGArticleBanner *)banner;
            [cell setCellWithArticle:articleBanner];
            
            return cell;
        } else if ([banner isKindOfClass:[PGGoodsCollectionBanner class]]) {
            PGGoodsCollectionBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodsCollectionBannerCell forIndexPath:indexPath];
            
            PGGoodsCollectionBanner *goodsCollectionBanner = (PGGoodsCollectionBanner *)banner;
            [cell setCellWithGoodsCollection:goodsCollectionBanner];
            
            return cell;
        } else if ([banner isKindOfClass:[PGTopicBanner class]]) {
            PGTopicBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TopicBannerCell forIndexPath:indexPath];
            
            PGTopicBanner *topicBanner = (PGTopicBanner *)banner;
            [cell setCellWithTopic:topicBanner];
            
            return cell;
        } else if ([banner isKindOfClass:[PGSingleGoodBanner class]]) {
            PGSingleGoodBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SingleGoodBannerCell forIndexPath:indexPath];
            
            PGSingleGoodBanner *singleGoodBanner = (PGSingleGoodBanner *)banner;
            [cell setCellWithSingleGood:singleGoodBanner];
            
            return cell;
        } else if ([banner isKindOfClass:[PGFlashbuyBanner class]]) {
            PGFlashbuyBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FlashbuyBannerCell forIndexPath:indexPath];
            
            PGFlashbuyBanner *flashbuyBanner = (PGFlashbuyBanner *)banner;
            [cell reloadBannersWithFlashbuy:flashbuyBanner];
            [cell countdown:flashbuyBanner];
            
            return cell;
        }
    }
    
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && kind == UICollectionElementKindSectionHeader) {
        NSString *tabType = [self.feedsDelegate tabType];
        if ([tabType isEqualToString:@"home"]) {
            PGHomeRecommendsHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomeHeaderView forIndexPath:indexPath];
            headerView.delegate = self;
            [headerView reloadBannersWithRecommendsArray:[self.feedsDelegate recommendsArray] channelsArray:[self.feedsDelegate iconsArray]];
            
            return headerView;
        } else if ([tabType isEqualToString:@"explore"]) {
            PGExploreRecommendsHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:ExploreHeaderView forIndexPath:indexPath];
            headerView.delegate = self;
            [headerView reloadBannersWithData:[self.feedsDelegate recommendsArray]];
            
            return headerView;
        } else if ([tabType isEqualToString:@"store"]) {
            PGStoreRecommendsHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:StoreHeaderView forIndexPath:indexPath];
            headerView.delegate = self;
            [headerView reloadBannersWithRecommendsArray:[self.feedsDelegate recommendsArray] categoriesArray:[self.feedsDelegate iconsArray]];
            
            return headerView;
        }
    }
    
    return nil;
}

#pragma mark - <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.feedsDelegate && [self.feedsDelegate respondsToSelector:@selector(feedsArray)]) {
        NSArray *feedsArray = [self.feedsDelegate feedsArray];
        
        id banner = feedsArray[indexPath.section];
        if ([banner isKindOfClass:[PGCarouselBanner class]]) {
            return [PGCarouselBannerCell cellSize];
        } else if ([banner isKindOfClass:[PGArticleBanner class]]) {
            return [PGArticleBannerCell cellSize];
        } else if ([banner isKindOfClass:[PGGoodsCollectionBanner class]]) {
            return [PGGoodsCollectionBannerCell cellSize];
        } else if ([banner isKindOfClass:[PGTopicBanner class]]) {
            return [PGTopicBannerCell cellSize];
        } else if ([banner isKindOfClass:[PGSingleGoodBanner class]]) {
            return [PGSingleGoodBannerCell cellSize];
        } else if ([banner isKindOfClass:[PGFlashbuyBanner class]]) {
            return [PGFlashbuyBannerCell cellSize];
        }
    }
    
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.feedsDelegate && [self.feedsDelegate respondsToSelector:@selector(feedsHeaderSize)]) {
            return [self.feedsDelegate feedsHeaderSize];
        }
    }

    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (self.feedsDelegate && [self.feedsDelegate respondsToSelector:@selector(topEdgeInsets)]) {
        if (section == 0) {
            return [self.feedsDelegate topEdgeInsets];
        }
    }
    return UIEdgeInsetsMake(0, 0, 7, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.feedsDelegate && [self.feedsDelegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
        [self.feedsDelegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.feedsDelegate && [self.feedsDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.feedsDelegate scrollViewDidScroll:scrollView];
    }
}

#pragma mark - <PGHomeRecommendsHeaderViewDelegate>

- (void)channelDidSelect:(NSString *)channelType
{
    if (self.feedsDelegate && [self.feedsDelegate respondsToSelector:@selector(channelDidSelect:)]) {
        [self.feedsDelegate channelDidSelect:channelType];
    }
}

#pragma mark - <PGExploreRecommendsHeaderViewDelegate>

- (void)scenarioDidSelect:(NSString *)scenarioType
{
    if (self.feedsDelegate && [self.feedsDelegate respondsToSelector:@selector(scenarioDidSelect:)]) {
        [self.feedsDelegate scenarioDidSelect:scenarioType];
    }
}

#pragma mark - <PGStoreRecommendsHeaderViewDelegate>

- (void)categoryDidSelect:(PGCategoryIcon *)categoryIcon
{
    if (self.feedsDelegate && [self.feedsDelegate respondsToSelector:@selector(categoryDidSelect:)]) {
        [self.feedsDelegate categoryDidSelect:categoryIcon];
    }
}

@end
