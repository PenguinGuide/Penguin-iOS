//
//  PGPullRefreshControl.h
//  Penguin
//
//  Created by Jing Dai on 22/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGPullRefreshControl : UIView

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, copy) void (^pullRefreshActionHandler)(void);

@property (nonatomic, strong) NSArray *loadingImages;
@property (nonatomic, assign) float topInset;
@property (nonatomic, assign) float height;
@property (nonatomic, assign) float rate;

- (void)invalidate;
- (void)endPullRefresh;

@end
