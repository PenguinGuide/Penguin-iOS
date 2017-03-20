//
//  PGFeedsCollectionView.m
//  Penguin
//
//  Created by Jing Dai on 8/29/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define PreloadCount 3

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

@interface PGFeedsCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

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
        self.backgroundColor = [UIColor whiteColor];
        self.allowGesture = YES;
        
        [self registerClass:[PGCarouselBannerCell class] forCellWithReuseIdentifier:CarouselBannerCell];
        [self registerClass:[PGArticleBannerCell class] forCellWithReuseIdentifier:ArticleBannerCell];
        [self registerClass:[PGGoodsCollectionBannerCell class] forCellWithReuseIdentifier:GoodsCollectionBannerCell];
        [self registerClass:[PGTopicBannerCell class] forCellWithReuseIdentifier:TopicBannerCell];
        [self registerClass:[PGSingleGoodBannerCell class] forCellWithReuseIdentifier:SingleGoodBannerCell];
        [self registerClass:[PGFlashbuyBannerCell class] forCellWithReuseIdentifier:FlashbuyBannerCell];
        
        [self registerClass:[PGExploreRecommendsHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ExploreHeaderView];
        [self registerClass:[PGBaseCollectionViewFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:BaseCollectionViewFooterView];
    }
    return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    // FIXME: if feedsArray is empty, header view will not show up
    if (self.feedsDelegate && [self.feedsDelegate respondsToSelector:@selector(feedsArray)]) {
        return [self.feedsDelegate feedsArray].count == 0 ? 0 : [self.feedsDelegate feedsArray].count;
    } else {
        return 0;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.feedsDelegate && [self.feedsDelegate respondsToSelector:@selector(feedsArray)]) {
        NSArray *feedsArray = [self.feedsDelegate feedsArray];
        
        if (feedsArray.count > 0) {
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
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.feedsDelegate && [self.feedsDelegate respondsToSelector:@selector(feedsArray)]) {
        NSArray *feedsArray = [self.feedsDelegate feedsArray];
        
        // NOTE: preloading http://www.tuicool.com/articles/qYFneuV
        if (feedsArray.count-indexPath.section == PreloadCount) {
            if (self.feedsDelegate && [self.feedsDelegate respondsToSelector:@selector(shouldPreloadNextPage)]) {
                [self.feedsDelegate shouldPreloadNextPage];
            }
        }
        
        id banner = feedsArray[indexPath.section];
        
        if ([banner isKindOfClass:[PGCarouselBanner class]]) {
            PGCarouselBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CarouselBannerCell forIndexPath:indexPath];
            
            PGCarouselBanner *carouselBanner = (PGCarouselBanner *)banner;
            if ([[self.feedsDelegate tabType] isEqualToString:@"store"]) {
                cell.pageName = store_tab_view;
            } else if ([[self.feedsDelegate tabType] isEqualToString:@"scenario"]) {
                cell.pageName = scenario_view;
            }
            
            [cell reloadBannersWithData:carouselBanner.banners];
            
            return cell;
        } else if ([banner isKindOfClass:[PGArticleBanner class]]) {
            PGArticleBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleBannerCell forIndexPath:indexPath];
            
            PGArticleBanner *articleBanner = (PGArticleBanner *)banner;
            cell.eventName = article_banner_clicked;
            cell.eventId = articleBanner.articleId;
            if ([[self.feedsDelegate tabType] isEqualToString:@"store"]) {
                cell.pageName = store_tab_view;
            } else if ([[self.feedsDelegate tabType] isEqualToString:@"scenario"]) {
                cell.pageName = scenario_view;
            }
            if (articleBanner.title) {
                cell.extraParams = @{@"article_title":articleBanner.title};
            }
            
            [cell setCellWithArticle:articleBanner allowGesture:self.allowGesture];
            
            return cell;
        } else if ([banner isKindOfClass:[PGGoodsCollectionBanner class]]) {
            PGGoodsCollectionBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodsCollectionBannerCell forIndexPath:indexPath];
            
            PGGoodsCollectionBanner *goodsCollectionBanner = (PGGoodsCollectionBanner *)banner;
            if ([[self.feedsDelegate tabType] isEqualToString:@"store"]) {
                cell.pageName = store_tab_view;
            } else if ([[self.feedsDelegate tabType] isEqualToString:@"scenario"]) {
                cell.pageName = scenario_view;
            }
            
            [cell setCellWithGoodsCollection:goodsCollectionBanner];
            
            return cell;
        } else if ([banner isKindOfClass:[PGTopicBanner class]]) {
            PGTopicBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TopicBannerCell forIndexPath:indexPath];
            
            PGTopicBanner *topicBanner = (PGTopicBanner *)banner;
            cell.eventName = topic_banner_clicked;
            cell.eventId = topicBanner.link;
            if ([[self.feedsDelegate tabType] isEqualToString:@"store"]) {
                cell.pageName = store_tab_view;
            } else if ([[self.feedsDelegate tabType] isEqualToString:@"scenario"]) {
                cell.pageName = scenario_view;
            }
            
            [cell setCellWithTopic:topicBanner];
            
            return cell;
        } else if ([banner isKindOfClass:[PGSingleGoodBanner class]]) {
            PGSingleGoodBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SingleGoodBannerCell forIndexPath:indexPath];
            
            PGSingleGoodBanner *singleGoodBanner = (PGSingleGoodBanner *)banner;
            cell.eventName = single_good_banner_clicked;
            cell.eventId = singleGoodBanner.goodsId;
            if ([[self.feedsDelegate tabType] isEqualToString:@"store"]) {
                cell.pageName = store_tab_view;
            } else if ([[self.feedsDelegate tabType] isEqualToString:@"scenario"]) {
                cell.pageName = scenario_view;
            }
            
            [cell setCellWithSingleGood:singleGoodBanner];
            
            return cell;
        } else if ([banner isKindOfClass:[PGFlashbuyBanner class]]) {
            PGFlashbuyBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FlashbuyBannerCell forIndexPath:indexPath];
            
            PGFlashbuyBanner *flashbuyBanner = (PGFlashbuyBanner *)banner;
            if ([[self.feedsDelegate tabType] isEqualToString:@"store"]) {
                cell.pageName = store_tab_view;
            } else if ([[self.feedsDelegate tabType] isEqualToString:@"scenario"]) {
                cell.pageName = scenario_view;
            }
            
            [cell reloadBannersWithFlashbuy:flashbuyBanner];
            [cell countdown:flashbuyBanner];
            
            return cell;
        }
    }
    
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (self.feedsDelegate && [self.feedsDelegate respondsToSelector:@selector(feedsArray)]) {
        NSArray *feedsArray = [self.feedsDelegate feedsArray];
        if (section == feedsArray.count-1) {
            if (self.feedsDelegate && [self.feedsDelegate respondsToSelector:@selector(feedsFooterSize)]) {
                return [self.feedsDelegate feedsFooterSize];
            }
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
    NSArray *feedsArray = [self.feedsDelegate feedsArray];
    id banner = feedsArray[section];
    
    if ([banner isKindOfClass:[PGArticleBanner class]]) {
        if (section == 0) {
            id nextBanner = feedsArray[section+1];
            if ([nextBanner isKindOfClass:[PGArticleBanner class]]) {
                return UIEdgeInsetsMake(15, 0, 0, 0);
            } else {
                return UIEdgeInsetsMake(15, 0, 15, 0);
            }
        } else if (section+1 < feedsArray.count) {
            id nextBanner = feedsArray[section+1];
            if ([nextBanner isKindOfClass:[PGArticleBanner class]]) {
                return UIEdgeInsetsZero;
            } else {
                return UIEdgeInsetsMake(0, 0, 15, 0);
            }
        } else {
            return UIEdgeInsetsZero;
        }
    } else if (section == feedsArray.count-1) {
        return UIEdgeInsetsMake(15, 0, 0, 0);
    } else {
        if (section == 0) {
            return UIEdgeInsetsMake(15, 0, 15, 0);
        } else {
            return UIEdgeInsetsMake(0, 0, 15, 0);
        }
    }
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

- (void)scenarioDidSelect:(PGScenarioBanner *)scenario
{
    if (self.feedsDelegate && [self.feedsDelegate respondsToSelector:@selector(scenarioDidSelect:)]) {
        [self.feedsDelegate scenarioDidSelect:scenario];
    }
}

#pragma mark - <PGStoreRecommendsHeaderViewDelegate>

- (void)categoryDidSelect:(PGScenarioBanner *)categoryIcon
{
    if (self.feedsDelegate && [self.feedsDelegate respondsToSelector:@selector(categoryDidSelect:)]) {
        [self.feedsDelegate categoryDidSelect:categoryIcon];
    }
}

@end
