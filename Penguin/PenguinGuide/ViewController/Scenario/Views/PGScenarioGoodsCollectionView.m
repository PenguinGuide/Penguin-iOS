//
//  PGScenarioGoodsCollectionView.m
//  Penguin
//
//  Created by Jing Dai on 05/12/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGScenarioGoodsCollectionView.h"

@interface PGScenarioGoodsCollectionView () <UIGestureRecognizerDelegate>

@end

@implementation PGScenarioGoodsCollectionView

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
