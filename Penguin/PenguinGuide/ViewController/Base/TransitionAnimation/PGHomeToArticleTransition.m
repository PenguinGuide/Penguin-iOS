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
    __block PGHomeViewController *homeVC = [tabBarController.viewControllers objectAtIndex:0];
    __block PGArticleViewController *articleVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    // http://blog.sina.com.cn/s/blog_8764c3140100xfo7.html
    __block PGArticleBannerCell *cell = (PGArticleBannerCell *)[homeVC.feedsCollectionView cellForItemAtIndexPath:[[homeVC.feedsCollectionView indexPathsForSelectedItems] firstObject]];
    if (cell) {
        CGRect rect = [containerView convertRect:cell.bannerImageView.frame fromView:cell.bannerImageView.superview];
        
        CGRect topScreenshotRect = CGRectMake(0, 0, rect.size.width, rect.origin.y+rect.size.height);
        CGFloat bottomScreenshotHeight = homeVC.feedsCollectionView.pg_height-topScreenshotRect.size.height;
        __block UIImageView *topScreenshotView = [[UIImageView alloc] init];
        if (topScreenshotRect.size.height < cell.frame.size.height) {
            topScreenshotView.frame = CGRectMake(0, topScreenshotRect.size.height-rect.size.height, cell.bannerImageView.pg_width, cell.bannerImageView.pg_height);
            topScreenshotView.image = cell.bannerImageView.image;
            
            UIImageView *realBannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.bannerImageView.pg_width, cell.bannerImageView.pg_height)];
            realBannerImageView.clipsToBounds = YES;
            realBannerImageView.contentMode = UIViewContentModeScaleAspectFill;
            realBannerImageView.image = cell.bannerImageView.image;
            
            UIView *dimView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, realBannerImageView.pg_width, realBannerImageView.pg_height)];
            dimView.backgroundColor = [UIColor blackColorWithAlpha:0.3];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (realBannerImageView.pg_height-16)/2-10, UISCREEN_WIDTH, 16)];
            titleLabel.font = Theme.fontLargeBold;
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.text = cell.titleLabel.text;
            [dimView addSubview:titleLabel];
            
            UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLabel.pg_bottom+10, UISCREEN_WIDTH, 14)];
            subtitleLabel.font = Theme.fontSmall;
            subtitleLabel.textColor = [UIColor whiteColor];
            subtitleLabel.textAlignment = NSTextAlignmentCenter;
            subtitleLabel.text = cell.subtitleLabel.text;
            [dimView addSubview:subtitleLabel];
            
            [realBannerImageView addSubview:dimView];
            [topScreenshotView addSubview:realBannerImageView];
        } else {
            UIImage *topScreenshot = [homeVC.feedsCollectionView screenshotFromRect:topScreenshotRect];
            if (bottomScreenshotHeight < 0) {
                topScreenshotView.frame = CGRectMake(0, 0, topScreenshot.size.width, topScreenshot.size.height-bottomScreenshotHeight);
            } else {
                topScreenshotView.frame = CGRectMake(0, 0, topScreenshot.size.width, topScreenshot.size.height);
            }
            topScreenshotView.image = topScreenshot;
            
            UIImageView *realBannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, topScreenshotRect.size.height-rect.size.height, rect.size.width, rect.size.height)];
            realBannerImageView.clipsToBounds = YES;
            realBannerImageView.contentMode = UIViewContentModeScaleAspectFill;
            realBannerImageView.image = cell.bannerImageView.image;
            
            UIView *dimView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, realBannerImageView.pg_width, realBannerImageView.pg_height)];
            dimView.backgroundColor = [UIColor blackColorWithAlpha:0.3];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (realBannerImageView.pg_height-16)/2-10, UISCREEN_WIDTH, 16)];
            titleLabel.font = Theme.fontLargeBold;
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.text = cell.titleLabel.text;
            [dimView addSubview:titleLabel];
            
            UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLabel.pg_bottom+10, UISCREEN_WIDTH, 14)];
            subtitleLabel.font = Theme.fontSmall;
            subtitleLabel.textColor = [UIColor whiteColor];
            subtitleLabel.textAlignment = NSTextAlignmentCenter;
            subtitleLabel.text = cell.subtitleLabel.text;
            [dimView addSubview:subtitleLabel];
            
            [realBannerImageView addSubview:dimView];
            [topScreenshotView addSubview:realBannerImageView];
        }
        
        __block UIImageView *bottomScreenshotView = nil;
        if (bottomScreenshotHeight > 0.f) {
            CGRect bottomScreenshotRect = CGRectMake(0, topScreenshotRect.size.height, topScreenshotRect.size.width, homeVC.feedsCollectionView.pg_height-topScreenshotRect.size.height);
            UIImage *bottomScreenshot = [homeVC.feedsCollectionView screenshotFromRect:bottomScreenshotRect];
            bottomScreenshotView = [[UIImageView alloc] initWithFrame:CGRectMake(0, topScreenshotView.pg_bottom, bottomScreenshot.size.width, bottomScreenshot.size.height)];
            bottomScreenshotView.image = bottomScreenshot;
        }
        
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
                             topScreenshotView.frame = CGRectMake(frame.origin.x, -(topScreenshotView.pg_height-frame.size.height), topScreenshotView.pg_width, topScreenshotView.pg_height);
                             if (bottomScreenshotView) {
                                 bottomScreenshotView.frame = CGRectMake(bottomScreenshotView.pg_x, UISCREEN_HEIGHT, bottomScreenshotView.pg_width, bottomScreenshotView.pg_height);
                             }
                             articleVC.view.alpha = 1.f;
                         } completion:^(BOOL finished) {
                             [articleVC animateCollectionView:^{
                                 [topScreenshotView removeFromSuperview];
                                 [bottomScreenshotView removeFromSuperview];
                                 homeVC.feedsCollectionView.hidden = NO;
                                 cell.bannerImageView.hidden = NO;
                                 articleVC.headerImageView.hidden = NO;
                             }];
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         }];
    } else {
        [containerView addSubview:articleVC.view];
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }
}

@end
