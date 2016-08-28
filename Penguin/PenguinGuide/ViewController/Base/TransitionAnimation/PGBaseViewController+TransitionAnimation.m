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
//    if (operation == UINavigationControllerOperationPush) {
//        if ([fromVC isKindOfClass:[PGTabBarController class]]) {
//            if ([toVC isKindOfClass:[PGArticleViewController class]]) {
//                return [[PGHomeToArticleTransition alloc] init];
//            }
//        } else {
//            
//        }
//    } else if (operation == UINavigationControllerOperationPop) {
//        if ([toVC isKindOfClass:[PGTabBarController class]]) {
//            if ([fromVC isKindOfClass:[PGArticleViewController class]]) {
//                return [[PGArticleToHomeTransition alloc] init];
//            }
//        } else {
//            
//        }
//    }

    return nil;
}

@end
