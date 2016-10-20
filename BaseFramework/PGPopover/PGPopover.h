//
//  PGPopover.h
//  Penguin
//
//  Created by Jing Dai on 9/1/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGPopoverItem.h"

@protocol PGPopoverDelegate <NSObject>

- (void)itemDidSelect:(NSInteger)index;

@end

@interface PGPopover : UIView

@property (nonatomic, weak) id<PGPopoverDelegate> delegate;

+ (PGPopover *)popoverWithItems:(NSArray *)items itemHeight:(CGFloat)itemHeight;

- (void)showPopoverFromView:(UIView *)view;

@end
