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
    
    CGRect topScreenshotRect = CGRectMake(0, 0, rect.size.width, rect.origin.y+rect.size.height);
    UIImageView *topScreenshotView = [[UIImageView alloc] init];
    if (topScreenshotRect.size.height < cell.frame.size.height) {
        topScreenshotView.frame = CGRectMake(0, 0, cell.bannerImageView.image.size.width, cell.bannerImageView.image.size.height);
        topScreenshotView.image = cell.bannerImageView.image;
    } else {
        UIImage *topScreenshot = [homeVC.feedsCollectionView screenshotFromRect:topScreenshotRect];
        topScreenshotView.frame = CGRectMake(0, 0, topScreenshot.size.width, topScreenshot.size.height);
        topScreenshotView.image = topScreenshot;
    }
    
    CGRect bottomScreenshotRect = CGRectMake(0, topScreenshotRect.size.height, topScreenshotRect.size.width, homeVC.feedsCollectionView.height-topScreenshotRect.size.height);
    UIImage *bottomScreenshot = [homeVC.feedsCollectionView screenshotFromRect:bottomScreenshotRect];
    UIImageView *bottomScreenshotView = [[UIImageView alloc] initWithFrame:CGRectMake(0, topScreenshotView.bottom, bottomScreenshot.size.width, bottomScreenshot.size.height)];
    bottomScreenshotView.image = bottomScreenshot;
    
    homeVC.feedsCollectionView.hidden = YES;
    
    articleVC.view.frame = [transitionContext finalFrameForViewController:articleVC];
    articleVC.view.alpha = 0.f;
    articleVC.headerImageView.hidden = YES;
    
    [containerView addSubview:articleVC.view];
    [containerView addSubview:topScreenshotView];
    [containerView addSubview:bottomScreenshotView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         CGRect frame = [containerView convertRect:articleVC.headerImageView.frame fromView:articleVC.headerImageView.superview];
                         topScreenshotView.frame = CGRectMake(frame.origin.x, -(topScreenshotView.height-frame.size.height), topScreenshotView.width, topScreenshotView.height);
                         bottomScreenshotView.frame = CGRectMake(bottomScreenshotView.x, UISCREEN_HEIGHT, bottomScreenshotView.width, bottomScreenshotView.height);
                         articleVC.view.alpha = 1.f;
                     } completion:^(BOOL finished) {
                         [articleVC animateCollectionView:^{
                             [topScreenshotView removeFromSuperview];
                             [bottomScreenshotView removeFromSuperview];
                             homeVC.feedsCollectionView.hidden = NO;
                             cell.bannerImageView.hidden = NO;
                             articleVC.headerImageView.hidden = NO;
                             
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         }];
                     }];
}

@end
