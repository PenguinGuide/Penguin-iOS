//
//  PGPullRefreshControl.m
//  Penguin
//
//  Created by Jing Dai on 22/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

typedef NS_ENUM(NSInteger, PullRefreshControlState) {
    PullRefreshControlStateLoading,
    PullRefreshControlStateTriggered
};

#import "PGPullRefreshControl.h"

@interface PGPullRefreshControl ()

@property (nonatomic, strong) UIImageView *animatedImageView;
@property (nonatomic, assign) PullRefreshControlState state;

@end

@implementation PGPullRefreshControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.scrollView removeObserver:self forKeyPath:@"pan.state"];
    self.scrollView = nil;
}

- (void)initialize
{
    self.backgroundColor = [UIColor clearColor];
    
    self.animatedImageView = [[UIImageView alloc] init];
    self.animatedImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.animatedImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    
    [self addSubview:self.animatedImageView];
}

- (void)invalidate
{
    if (self.scrollView) {
        [self.scrollView addObserver:self forKeyPath:@"pan.state" options:NSKeyValueObservingOptionNew context:nil];
        [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    if (self.loadingImages.count > 0 && [[self.loadingImages firstObject] isKindOfClass:[UIImage class]]) {
        UIImage *firstImage = self.loadingImages.firstObject;
        self.animatedImageView.frame = CGRectMake(0, self.topInset, self.frame.size.width, firstImage.size.height);
        self.animatedImageView.image = firstImage;
        self.animatedImageView.animationImages = self.loadingImages;
    }
}

- (void)endPullRefresh
{
    self.state = PullRefreshControlStateLoading;
    if (self.scrollView.contentOffset.y <= 0) {
        [self.scrollView setContentOffset:CGPointZero animated:YES];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"pan.state"]) {
        UIGestureRecognizerState state = self.scrollView.panGestureRecognizer.state;
        if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged) {
            self.state = PullRefreshControlStateLoading;
            //NSLog(@"pull to refresh loading");
        } else {
            self.state = PullRefreshControlStateTriggered;
            //NSLog(@"pull to refresh triggered");
        }
    }
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        if (self.scrollView.contentOffset.y <= 0) {
            float percentage = fabsf(self.scrollView.contentOffset.y)/self.height;
            if (percentage >= 0.f && percentage < 1.f) {
                if (self.state == PullRefreshControlStateLoading) {
                    [self.animatedImageView stopAnimating];
                    NSInteger index = (self.loadingImages.count-1)*percentage;
                    self.animatedImageView.image = self.loadingImages[index];
                }
            } else if (percentage >= 1.f) {
                if (self.state == PullRefreshControlStateTriggered) {
                    if (!self.animatedImageView.isAnimating) {
                        [self.animatedImageView startAnimating];
                        [self.scrollView setContentOffset:CGPointMake(0, -self.height) animated:YES];
                        
                        if (self.pullRefreshActionHandler) {
                            self.pullRefreshActionHandler();
                        }
                    }
                } else {
                    [self.animatedImageView stopAnimating];
                    self.animatedImageView.image = self.loadingImages[self.loadingImages.count-1];
                }
            }
        } else {
            
        }
    }
}

@end
