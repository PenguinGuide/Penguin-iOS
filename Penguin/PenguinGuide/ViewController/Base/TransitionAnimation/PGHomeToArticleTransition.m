//
//  PGHomeToArticleTransition.m
//  Penguin
//
//  Created by Jing Dai on 7/15/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGHomeToArticleTransition.h"

#import "PGTabBarController.h"
#import "PGHomeViewController.h"
#import "PGArticleViewController.h"

#import "PGArticleBannerCell.h"

@implementation PGHomeToArticleTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    PGTabBarController *tabBarController = (PGTabBarController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    PGHomeViewController *homeVC = [tabBarController.viewControllers objectAtIndex:0];
    PGArticleViewController *articleVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    // http://blog.sina.com.cn/s/blog_8764c3140100xfo7.html
    PGArticleBannerCell *cell = (PGArticleBannerCell *)[homeVC.feedsCollectionView cellForItemAtIndexPath:[[homeVC.feedsCollectionView indexPathsForSelectedItems] firstObject]];
    CGRect rect = [containerView convertRect:cell.bannerImageView.frame fromView:cell.bannerImageView.superview];
    
    UIView *screenshot = [cell.bannerImageView snapshotViewAfterScreenUpdates:NO];  // if set to YES, screenshot will be empty since cell.bannerImageView.hidden set to YES
    screenshot.frame = rect;
    cell.bannerImageView.hidden = YES;
    
    articleVC.view.frame = [transitionContext finalFrameForViewController:articleVC];
    articleVC.view.alpha = 0.f;
    articleVC.imageView.hidden = YES;
    
    [containerView addSubview:articleVC.view];
    [containerView addSubview:screenshot];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         screenshot.frame = [containerView convertRect:articleVC.imageView.frame fromView:articleVC.imageView.superview];
                         articleVC.view.alpha = 1.f;
                     } completion:^(BOOL finished) {
                         [screenshot removeFromSuperview];
                         cell.bannerImageView.hidden = NO;
                         articleVC.imageView.hidden = NO;
                         
                         [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                     }];
}

@end
