//
//  PGBaseCollectionView.m
//  Penguin
//
//  Created by Jing Dai on 7/7/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseCollectionView.h"
#import "UIScrollView+PGPullToRefresh.h"
//#import "UIScrollView+UzysAnimatedGifPullToRefresh.h"
#import "SVPullToRefresh.h"

@implementation PGBaseCollectionView

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.backgroundColor = [UIColor whiteColor];
        self.alwaysBounceVertical = YES;
        
        [self registerClass:[PGBaseCollectionViewFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:BaseCollectionViewFooterView];
    }
    
    return self;
}

- (void)enablePullToRefreshWithTopInset:(CGFloat)topInset completion:(void (^)(void))completion
{
    [self addPullToRefresh:Theme.loadingImages
                  topInset:64-36-5
                    height:64.f
                      rate:0.f
                   handler:^{
                       if (completion) {
                           completion();
                       }
                   }];
}

- (void)enableInfiniteScrolling:(void (^)(void))completion
{
    [self addInfiniteScrollingWithActionHandler:^{
        if (completion) {
            completion();
        }
    }];
}

- (void)enableInfiniteScrolling
{
    self.showsInfiniteScrolling = YES;
}

- (void)disableInfiniteScrolling
{
    self.showsInfiniteScrolling = NO;
}

- (void)endTopRefreshing
{
    [self endPullToRefresh];
}

- (void)endBottomRefreshing
{
    [self.infiniteScrollingView stopAnimating];
}

@end
