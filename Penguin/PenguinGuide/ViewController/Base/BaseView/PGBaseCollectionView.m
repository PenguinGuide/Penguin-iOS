//
//  PGBaseCollectionView.m
//  Penguin
//
//  Created by Jing Dai on 7/7/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseCollectionView.h"
#import "UIScrollView+UzysAnimatedGifPullToRefresh.h"
#import "SVPullToRefresh.h"

@implementation PGBaseCollectionView

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.backgroundColor = [UIColor whiteColor];
        self.alwaysBounceVertical = YES;
    }
    
    return self;
}

- (void)enablePullToRefresh:(void (^)(void))completion
{
    [self addPullToRefreshActionHandler:^{
        if (completion) {
            completion();
        }
    } ProgressImages:Theme.loadingImages LoadingImages:Theme.loadingImages ProgressScrollThreshold:60 LoadingImagesFrameRate:35];
    
    [self addTopInsetInPortrait:0 TopInsetInLandscape:0];
}

- (void)enableInfiniteScrolling:(void (^)(void))completion
{
    [self addInfiniteScrollingWithActionHandler:^{
        if (completion) {
            completion();
        }
    }];
}

- (void)endTopRefreshing
{
    [self stopPullToRefreshAnimation];
}

- (void)endBottomRefreshing
{
    [self.infiniteScrollingView stopAnimating];
}

@end
