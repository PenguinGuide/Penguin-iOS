//
//  PGBaseViewController+TransitionAnimation.m
//  Penguin
//
//  Created by Jing Dai on 7/15/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewController+TransitionAnimation.h"
// view controllers
#import "PGTabBarController.h"
#import "PGExploreViewController.h"
#import "PGCityGuideViewController.h"
#import "PGCityGuideArticlesViewController.h"
#import "PGArticleViewController.h"
// transitions
#import "PGExploreToArticleTransition.h"
#import "PGCityGuideToArticleTransition.h"

#import "PGArticleBannerCell.h"

@implementation PGBaseViewController (TransitionAnimation)

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush) {
//        if ([fromVC isKindOfClass:[PGTabBarController class]]) {
//            PGTabBarController *tabbarController = (PGTabBarController *)fromVC;
//            if ([toVC isKindOfClass:[PGArticleViewController class]]) {
//                PGArticleViewController *articleVC = (PGArticleViewController *)toVC;
//                if (!articleVC.disableTransition) {
//                    if ([tabbarController.selectedViewController isKindOfClass:[PGExploreViewController class]]) {
//                        PGExploreViewController *exploreVC = (PGExploreViewController *)tabbarController.selectedViewController;
//                        NSIndexPath *selectedIndexPath = [exploreVC.feedsCollectionView indexPathsForSelectedItems].firstObject;
//                        PGArticleBannerCell *cell = (PGArticleBannerCell *)[exploreVC.feedsCollectionView cellForItemAtIndexPath:selectedIndexPath];
//                        if (cell) {
//                            return [[PGExploreToArticleTransition alloc] init];
//                        } else {
//                            return nil;
//                        }
//                    } else if ([tabbarController.selectedViewController isKindOfClass:[PGCityGuideViewController class]]) {
////                        PGCityGuideViewController *cityGuideVC = (PGCityGuideViewController *)tabbarController.selectedViewController;
////                        PGCityGuideArticlesViewController *cityGuideArticlesVC = cityGuideVC.pagedController.viewControllers[cityGuideVC.pagedController.currentPage];
////                        NSIndexPath *selectedIndexPath = [cityGuideArticlesVC.articlesCollectionView indexPathsForSelectedItems].firstObject;
////                        PGArticleBannerCell *cell = (PGArticleBannerCell *)[cityGuideArticlesVC.articlesCollectionView cellForItemAtIndexPath:selectedIndexPath];
////                        if (cell) {
////                            return [[PGCityGuideToArticleTransition alloc] init];
////                        } else {
////                            return nil;
////                        }
//                    }
//                } else {
//                    return nil;
//                }
//            }
//        } else {
//            
//        }
    } else if (operation == UINavigationControllerOperationPop) {
//        if ([toVC isKindOfClass:[PGTabBarController class]]) {
//            PGTabBarController *tabbarController = (PGTabBarController *)toVC;
//            if ([fromVC isKindOfClass:[PGArticleViewController class]]) {
//                if ([tabbarController.selectedViewController isKindOfClass:[PGHomeViewController class]]) {
//                    return [[PGArticleToHomeTransition alloc] init];
//                }
//            }
//        } else {
//            
//        }
    }

    return nil;
}

@end
