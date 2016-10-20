//
//  PGHomeViewController.h
//  Penguin
//
//  Created by Jing Dai on 7/8/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewController.h"
#import "PGScrollNavigationBar.h"
#import "PGTabBarControllerDelegate.h"
#import "PGFeedsCollectionView.h"

@interface PGHomeViewController : PGBaseViewController <PGTabBarControllerDelegate>

@property (nonatomic, strong, readonly) PGFeedsCollectionView *feedsCollectionView;

@end
