//
//  PGFeedsCollectionView.h
//  Penguin
//
//  Created by Jing Dai on 8/29/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseCollectionView.h"
#import "PGScenarioBanner.h"

// models
#import "PGCarouselBanner.h"
#import "PGArticleBanner.h"
#import "PGFlashbuyBanner.h"
#import "PGGoodsCollectionBanner.h"
#import "PGTopicBanner.h"
#import "PGSingleGoodBanner.h"
// cells
#import "PGCarouselBannerCell.h"
#import "PGArticleBannerCell.h"
#import "PGGoodsCollectionBannerCell.h"
#import "PGTopicBannerCell.h"
#import "PGSingleGoodBannerCell.h"
#import "PGFlashbuyBannerCell.h"

#import "PGExploreRecommendsHeaderView.h"

@protocol PGFeedsCollectionViewDelegate <NSObject>

@optional

- (NSString *)pageName;
- (NSArray *)feedsArray;
- (CGSize)feedsFooterSize;

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)shouldPreloadNextPage;

@end

@interface PGFeedsCollectionView : PGBaseCollectionView

@property (nonatomic, weak) id<PGFeedsCollectionViewDelegate> feedsDelegate;

@property (nonatomic, assign) BOOL allowGesture;

@end
