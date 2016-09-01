//
//  PGFeedsCollectionView.h
//  Penguin
//
//  Created by Jing Dai on 8/29/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseCollectionView.h"

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
- (NSString *)tabType;

@optional

- (void)channelDidSelect:(NSString *)channelType;
- (void)scenarioDidSelect:(NSString *)scenarioType;
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (UIEdgeInsets)topEdgeInsets;

@end

@interface PGFeedsCollectionView : PGBaseCollectionView

@property (nonatomic, weak) id<PGFeedsCollectionViewDelegate> feedsDelegate;

@end
