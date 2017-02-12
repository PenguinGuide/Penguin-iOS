//
//  UIViewController+PGPagedController.h
//  Penguin
//
//  Created by Jing Dai on 04/02/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGPagedController.h"
#import "PGSegmentedControlConfig.h"

@interface UIViewController (PGPagedController)

@property (nonatomic, strong, readonly) PGPagedController *pagedController;

- (void)addPagedController:(CGRect)frame viewControllers:(NSArray *)viewControllers segmentConfig:(void(^)(PGSegmentedControlConfig *config))configBlock;

- (void)addPagedController:(PGPagedController *)pagedController config:(void(^)(PGSegmentedControlConfig *config))configBlock;

@end
