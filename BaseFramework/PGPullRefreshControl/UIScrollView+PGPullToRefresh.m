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
    self.pullRefreshControl = [[PGPullRefreshControl alloc] initWithFrame:CGRectMake(0, -height, self.frame.size.width, height)];
    self.pullRefreshControl.loadingImages = loadingImages;
    self.pullRefreshControl.topInset = topInset;
    self.pullRefreshControl.height = height;
    self.pullRefreshControl.rate = rate;
    self.pullRefreshControl.scrollView = self;
    self.pullRefreshControl.pullRefreshActionHandler = actionHandler;
    
    [self.pullRefreshControl invalidate];
    
    [self addSubview:self.pullRefreshControl];
}

- (void)endPullToRefresh
{
    [self.pullRefreshControl endPullRefresh];
}

- (void)removePullToRefresh
{
    
}

- (PGPullRefreshControl *)pullRefreshControl
{
    return objc_getAssociatedObject(self, &pullRefreshControlKey);
}

- (void)setPullRefreshControl:(PGPullRefreshControl *)pullRefreshControl
{
    objc_setAssociatedObject(self, &pullRefreshControlKey, pullRefreshControl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
