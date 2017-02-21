//
//  PGSegmentedControl.h
//  Penguin
//
//  Created by Jing Dai on 24/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGPagedController.h"
#import "PGSegmentedControlConfig.h"

@interface PGSegmentedControl : UIControl

@property (nonatomic, weak) PGPagedController *pagedController;
@property (nonatomic, copy) void (^indexClicked)(NSInteger index);

- (id)initWithConfig:(PGSegmentedControlConfig *)config;

- (void)reload:(PGSegmentedControlConfig *)config;

- (void)scrollToPage:(NSInteger)page;

@end
