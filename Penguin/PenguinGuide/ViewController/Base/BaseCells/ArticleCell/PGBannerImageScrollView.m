//
//  PGBannerImageScrollView.m
//  Penguin
//
//  Created by Jing Dai on 16/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBannerImageScrollView.h"

@implementation PGBannerImageScrollView

// NOTE: fix article banners gesture issues, http://stackoverflow.com/questions/23841045/how-to-have-a-uiscrollview-scroll-and-have-a-gesture-recognizer
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer *)gestureRecognizer;
    CGPoint velocity = [recognizer velocityInView:self];
    if (abs((int)velocity.y) >= abs((int)velocity.x)) {
        return NO;
    } else {
        return YES;
    }
}

@end
