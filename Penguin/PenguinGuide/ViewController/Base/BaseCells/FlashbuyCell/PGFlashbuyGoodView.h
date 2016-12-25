//
//  PGFlashbuyGoodView.h
//  Penguin
//
//  Created by Jing Dai on 8/25/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGGood.h"

@interface PGFlashbuyGoodView : UIView

- (void)setViewWithGood:(PGGood *)good;
- (void)setCountDown:(NSDate *)startDate endDate:(NSDate *)endDate;

@end
