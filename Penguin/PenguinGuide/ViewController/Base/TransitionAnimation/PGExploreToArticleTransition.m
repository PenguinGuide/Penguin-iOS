//
//  PGExploreToArticleTransition.m
//  Penguin
//
//  Created by Kobe Dai on 19/12/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGExploreToArticleTransition.h"

#import "PGTabBarController.h"
#import "PGExploreViewController.h"
#import "PGArticleViewController.h"

#import "PGArticleBannerCell.h"

@implementation PGExploreToArticleTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    
    PGTabBarController *tabbarController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    PGExploreViewController *exploreVC = (PGExploreViewController *)tabbarController.selectedViewController;
    PGArticleViewController *articleVC = (PGArticleViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    NSIndexPath *selectedIndexPath = [exploreVC.feedsCollectionView indexPathsForSelectedItems].firstObject;
    PGArticleBannerCell *cell = (PGArticleBannerCell *)[exploreVC.feedsCollectionView cellForItemAtIndexPath:selectedIndexPath];
    
    if (cell) {
        CGRect rect = [containerView convertRect:cell.bannerImageView.frame fromView:cell.bannerImageView.superview];
        
        CGRect topScreenshotRect = CGRectMake(0, 0, rect.size.width, rect.origin.y+rect.size.height);
        CGFloat bottomScreenshotHeight = exploreVC.feedsCollectionView.pg_height-topScreenshotRect.size.height;
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
            UIImage *topScreenshot = [exploreVC.feedsCollectionView screenshotFromRect:topScreenshotRect];
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
            CGRect bottomScreenshotRect = CGRectMake(0, topScreenshotRect.size.height, topScreenshotRect.size.width, exploreVC.feedsCollectionView.pg_height-topScreenshotRect.size.height);
            UIImage *bottomScreenshot = [exploreVC.feedsCollectionView screenshotFromRect:bottomScreenshotRect];
            bottomScreenshotView = [[UIImageView alloc] initWithFrame:CGRectMake(0, topScreenshotView.pg_bottom, bottomScreenshot.size.width, bottomScreenshot.size.height)];
            bottomScreenshotView.image = bottomScreenshot;
        }
        
        exploreVC.feedsCollectionView.hidden = YES;
        
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
                                 exploreVC.feedsCollectionView.hidden = NO;
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

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3f;
}

@end
