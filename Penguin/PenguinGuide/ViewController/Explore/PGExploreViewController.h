//
//  PGExploreViewController.h
//  Penguin
//
//  Created by Jing Dai on 7/8/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewController.h"
#import "PGTabBarControllerDelegate.h"

@interface PGExploreViewController : PGBaseViewController <PGTabBarControllerDelegate>

@property (nonatomic, strong, readonly) PGBaseCollectionView *exploreCollectionView;

@end
