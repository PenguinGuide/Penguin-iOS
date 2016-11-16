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
#import "PGHomeViewController.h"
#import "PGArticleViewController.h"
// transitions
#import "PGHomeToArticleTransition.h"
#import "PGArticleToHomeTransition.h"

@implementation PGBaseViewController (TransitionAnimation)

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        if ([fromVC isKindOfClass:[PGTabBarController class]]) {
            PGTabBarController *tabbarController = (PGTabBarController *)fromVC;
            if ([toVC isKindOfClass:[PGArticleViewController class]]) {
                PGArticleViewController *articleVC = (PGArticleViewController *)toVC;
                if (!articleVC.disableTransition) {
                    if ([tabbarController.selectedViewController isKindOfClass:[PGHomeViewController class]]) {
                        PGHomeViewController *homeVC = (PGHomeViewController *)tabbarController.selectedViewController;
                        PGArticleBannerCell *cell = (PGArticleBannerCell *)[homeVC.feedsCollectionView cellForItemAtIndexPath:[[homeVC.feedsCollectionView indexPathsForSelectedItems] firstObject]];
                        if (cell) {
                            return [[PGHomeToArticleTransition alloc] init];
                        } else {
                            return nil;
                        }
                    }
                } else {
                    return nil;
                }
            }
        } else {
            
        }
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
