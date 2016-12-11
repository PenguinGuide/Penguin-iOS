//
//  PGScenarioPagedCollectionView.m
//  Penguin
//
//  Created by Jing Dai on 02/12/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGScenarioFeedsCollectionView.h"

@interface PGScenarioFeedsCollectionView () <UIGestureRecognizerDelegate>

@end

@implementation PGScenarioFeedsCollectionView

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
