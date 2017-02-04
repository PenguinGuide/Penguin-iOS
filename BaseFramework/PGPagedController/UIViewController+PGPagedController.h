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

- (void)addPagedController:(PGPagedController *)pagedController config:(void(^)(PGSegmentedControlConfig *config))configBlock;

@end
