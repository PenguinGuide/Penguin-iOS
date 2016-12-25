//
//  UIScrollView+PGPullToRefresh.h
//  Penguin
//
//  Created by Jing Dai on 22/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGPullRefreshControl.h"

@interface UIScrollView (PGPullToRefresh)

@property (nonatomic, strong) PGPullRefreshControl *pullRefreshControl;

- (void)addPullToRefresh:(NSArray *)loadingImages topInset:(float)topInset height:(float)height rate:(float)rate handler:(void(^)(void))actionHandler;
- (void)endPullToRefresh;
- (void)removePullToRefresh;

@end
