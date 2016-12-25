//
//  PGScenarioPagerCollectionView.m
//  Penguin
//
//  Created by Jing Dai on 04/12/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGScenarioPagerCollectionView.h"

@interface PGScenarioPagerCollectionView () <UIGestureRecognizerDelegate>

@end

@implementation PGScenarioPagerCollectionView

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer *)gestureRecognizer;
    CGPoint velocity = [recognizer velocityInView:self];

    if (velocity.y >= 0) {
        // scroll down direction
        if (self.contentOffset.y == 0) {
            return NO;
        }
        return YES;
    } else {
        // scroll up direction
        if (self.contentOffset.y <= roundf(UISCREEN_WIDTH*9/16)) {
            return YES;
        } else {
            return NO;
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
