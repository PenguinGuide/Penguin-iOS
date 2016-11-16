//
//  PGFeedsCollectionView.h
//  Penguin
//
//  Created by Jing Dai on 8/29/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseCollectionView.h"
#import "PGCategoryIcon.h"

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

@protocol PGFeedsCollectionViewDelegate <NSObject>

- (NSArray *)recommendsArray;
- (NSArray *)feedsArray;
- (CGSize)feedsHeaderSize;
- (CGSize)feedsFooterSize;
- (NSString *)tabType;

@optional

- (NSArray *)iconsArray;
- (UIEdgeInsets)topEdgeInsets;

- (void)channelDidSelect:(NSString *)link;
- (void)scenarioDidSelect:(PGCategoryIcon *)scenario;
- (void)categoryDidSelect:(PGCategoryIcon *)category;

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)shouldPreloadNextPage;

@end

@interface PGFeedsCollectionView : PGBaseCollectionView

@property (nonatomic, weak) id<PGFeedsCollectionViewDelegate> feedsDelegate;

@end
