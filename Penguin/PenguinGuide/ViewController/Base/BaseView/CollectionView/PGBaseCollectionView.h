//
//  PGBaseCollectionView.h
//  Penguin
//
//  Created by Jing Dai on 7/7/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGBaseCollectionViewFooterView.h"

@interface PGBaseCollectionView : UICollectionView

- (void)enablePullToRefreshWithTopInset:(CGFloat)topInset completion:(void (^)(void))completion;
- (void)enableInfiniteScrolling:(void(^)(void))completion;

- (void)enableInfiniteScrolling;
- (void)disableInfiniteScrolling;

- (void)endTopRefreshing;
- (void)endBottomRefreshing;

@end
