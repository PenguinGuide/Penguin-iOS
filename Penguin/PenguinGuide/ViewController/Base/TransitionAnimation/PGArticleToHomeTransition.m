//
//  PGArticleToHomeTransition.m
//  Penguin
//
//  Created by Jing Dai on 7/18/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGArticleToHomeTransition.h"

#import "PGTabBarController.h"
#import "PGHomeViewController.h"
#import "PGArticleViewController.h"

#import "PGArticleBannerCell.h"

@implementation PGArticleToHomeTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    PGArticleViewController *articleVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UITabBarController *tabBarController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    PGHomeViewController *homeVC = [tabBarController.viewControllers objectAtIndex:0];
    PGArticleBannerCell *cell = (PGArticleBannerCell *)[homeVC.feedsCollectionView cellForItemAtIndexPath:[[homeVC.feedsCollectionView indexPathsForSelectedItems] firstObject]];
    
    UIView *containerView = [transitionContext containerView];
    
    // http://blog.sina.com.cn/s/blog_8764c3140100xfo7.html
    CGRect rect = [containerView convertRect:articleVC.imageView.frame fromView:articleVC.imageView.superview];
    UIView *screenshot = [articleVC.imageView snapshotViewAfterScreenUpdates:NO];
    screenshot.frame = rect;
    articleVC.imageView.hidden = YES;
    cell.bannerImageView.hidden = YES;
    
    tabBarController.view.frame = [transitionContext finalFrameForViewController:tabBarController];
    tabBarController.view.alpha = 0.f;
    
    [containerView insertSubview:tabBarController.view aboveSubview:articleVC.view];
    [containerView addSubview:screenshot];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         screenshot.frame = [containerView convertRect:cell.bannerImageView.frame fromView:cell.bannerImageView.superview];
                         tabBarController.view.alpha = 1.f;
                     } completion:^(BOOL finished) {
                         cell.bannerImageView.hidden = NO;
                         [screenshot removeFromSuperview];
                         [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                     }];
}

@end
