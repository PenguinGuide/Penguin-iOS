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
    } ProgressImagesGifName:@"pg_pull_to_refresh.gif" LoadingImagesGifName:@"pg_pull_to_refresh.gif" ProgressScrollThreshold:60 LoadingImageFrameRate:35];
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
