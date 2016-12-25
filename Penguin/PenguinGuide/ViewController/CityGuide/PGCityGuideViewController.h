//
//  PGCityGuideViewController.h
//  Penguin
//
//  Created by Jing Dai on 24/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewController.h"
#import "PGPagedController.h"

@interface PGCityGuideViewController : PGBaseViewController <PGTabBarControllerDelegate>

@property (nonatomic, strong, readonly) PGPagedController *pagedController;

@end
