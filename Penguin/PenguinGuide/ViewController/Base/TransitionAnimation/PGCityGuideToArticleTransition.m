//
//  PGCityGuideToArticleTransition.m
//  Penguin
//
//  Created by Kobe Dai on 19/12/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGCityGuideToArticleTransition.h"

#import "PGTabBarController.h"
#import "PGCityGuideViewController.h"
#import "PGCityGuideArticlesViewController.h"
#import "PGArticleViewController.h"

#import "PGArticleBannerCell.h"

@implementation PGCityGuideToArticleTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    
    PGTabBarController *tabbarController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    PGCityGuideViewController *cityGuideVC = (PGCityGuideViewController *)tabbarController.selectedViewController;
    PGCityGuideArticlesViewController *cityGuideArticlesVC = cityGuideVC.pagedController.viewControllers[cityGuideVC.pagedController.currentPage];
    PGArticleViewController *articleVC = (PGArticleViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    NSIndexPath *selectedIndexPath = [cityGuideArticlesVC.articlesCollectionView indexPathsForSelectedItems].firstObject;
    PGArticleBannerCell *cell = (PGArticleBannerCell *)[cityGuideArticlesVC.articlesCollectionView cellForItemAtIndexPath:selectedIndexPath];
    
    CGRect segmentScreenshotRect = CGRectMake(0, 0, UISCREEN_WIDTH, 60+20);
    
    if (cell) {
        CGRect rect = [containerView convertRect:cell.bannerImageView.frame fromView:cell.bannerImageView.superview];
        
        CGRect topScreenshotRect = CGRectMake(0, 0, rect.size.width, rect.origin.y+rect.size.height-80);
        CGFloat bottomScreenshotHeight = cityGuideArticlesVC.articlesCollectionView.pg_height-topScreenshotRect.size.height;
        __block UIImageView *topScreenshotView = [[UIImageView alloc] init];
        __block UIImageView *segmentScreenshotView = [[UIImageView alloc] initWithFrame:segmentScreenshotRect];
        if (topScreenshotRect.size.height < cell.frame.size.height) {
            [containerView addSubview:articleVC.view];
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            return;
        } else {
            UIImage *topScreenshot = [cityGuideArticlesVC.articlesCollectionView screenshotFromRect:topScreenshotRect];
            UIImage *segmentScreenshot = [cityGuideVC.view screenshotFromRect:segmentScreenshotRect];
            if (bottomScreenshotHeight < 0) {
                topScreenshotView.frame = CGRectMake(0, 80, topScreenshot.size.width, topScreenshot.size.height-bottomScreenshotHeight);
            } else {
                topScreenshotView.frame = CGRectMake(0, 80, topScreenshot.size.width, topScreenshot.size.height);
            }
            topScreenshotView.image = topScreenshot;
            segmentScreenshotView.image = segmentScreenshot;
            
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
            CGRect bottomScreenshotRect = CGRectMake(0, topScreenshotRect.size.height, topScreenshotRect.size.width, cityGuideArticlesVC.articlesCollectionView.pg_height-topScreenshotRect.size.height);
            UIImage *bottomScreenshot = [cityGuideArticlesVC.articlesCollectionView screenshotFromRect:bottomScreenshotRect];
            bottomScreenshotView = [[UIImageView alloc] initWithFrame:CGRectMake(0, topScreenshotView.pg_bottom, bottomScreenshot.size.width, bottomScreenshot.size.height)];
            bottomScreenshotView.image = bottomScreenshot;
        }
        
        cityGuideVC.pagedController.view.hidden = YES;
        cityGuideArticlesVC.articlesCollectionView.hidden = YES;
        
        articleVC.view.frame = [transitionContext finalFrameForViewController:articleVC];
        articleVC.view.alpha = 0.f;
        articleVC.headerImageView.hidden = YES;
        
        [containerView addSubview:segmentScreenshotView];
        [containerView addSubview:articleVC.view];
        [containerView addSubview:topScreenshotView];
        [containerView addSubview:bottomScreenshotView];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             CGRect frame = [containerView convertRect:articleVC.headerImageView.frame fromView:articleVC.headerImageView.superview];
                             segmentScreenshotView.frame = CGRectMake(0, -(topScreenshotView.pg_height-frame.size.height)-80, segmentScreenshotView.pg_width, segmentScreenshotView.pg_height);
                             topScreenshotView.frame = CGRectMake(frame.origin.x, -(topScreenshotView.pg_height-frame.size.height), topScreenshotView.pg_width, topScreenshotView.pg_height);
                             if (bottomScreenshotView) {
                                 bottomScreenshotView.frame = CGRectMake(bottomScreenshotView.pg_x, UISCREEN_HEIGHT, bottomScreenshotView.pg_width, bottomScreenshotView.pg_height);
                             }
                             articleVC.view.alpha = 1.f;
                         } completion:^(BOOL finished) {
                             [articleVC animateCollectionView:^{
                                 [topScreenshotView removeFromSuperview];
                                 [bottomScreenshotView removeFromSuperview];
                                 cityGuideVC.pagedController.view.hidden = NO;
                                 cityGuideArticlesVC.articlesCollectionView.hidden = NO;
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
