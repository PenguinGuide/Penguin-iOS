//
//  UIScrollView+PGPullToRefresh.m
//  Penguin
//
//  Created by Jing Dai on 22/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "UIScrollView+PGPullToRefresh.h"
#import <objc/runtime.h>

static char pullRefreshControlKey;

@implementation UIScrollView (PGPullToRefresh)

- (void)addPullToRefresh:(NSArray *)loadingImages topInset:(float)topInset height:(float)height rate:(float)rate handler:(void (^)(void))actionHandler
{
    PGPullRefreshControl *pullRefreshControl = [[PGPullRefreshControl alloc] initWithFrame:CGRectMake(0, -height, self.frame.size.width, height)];
    pullRefreshControl = [[PGPullRefreshControl alloc] initWithFrame:CGRectMake(0, -height, self.frame.size.width, height)];
    pullRefreshControl.loadingImages = loadingImages;
    pullRefreshControl.topInset = topInset;
    pullRefreshControl.height = height;
    pullRefreshControl.rate = rate;
    pullRefreshControl.scrollView = self;
    pullRefreshControl.pullRefreshActionHandler = [actionHandler copy];
    
    [pullRefreshControl invalidate];
    
    [self addSubview:pullRefreshControl];
    
    self.pullRefreshControl = pullRefreshControl;
}

- (void)endPullToRefresh
{
    [self.pullRefreshControl endPullRefresh];
}

- (void)removePullToRefresh
{
    [self.pullRefreshControl removeFromSuperview];
    self.pullRefreshControl = nil;
}

// without this method, app will crash
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if(newSuperview == nil) {
        [self removePullToRefresh];
    }
}

- (PGPullRefreshControl *)pullRefreshControl
{
    return objc_getAssociatedObject(self, &pullRefreshControlKey);
}

- (void)setPullRefreshControl:(PGPullRefreshControl *)pullRefreshControl
{
    objc_setAssociatedObject(self, &pullRefreshControlKey, pullRefreshControl, OBJC_ASSOCIATION_ASSIGN);
}

@end
