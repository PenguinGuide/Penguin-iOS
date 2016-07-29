//
//  PGHomeViewController.h
//  Penguin
//
//  Created by Jing Dai on 7/8/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewController.h"
#import "PGTabBarControllerDelegate.h"

@interface PGHomeViewController : PGBaseViewController <PGTabBarControllerDelegate>

@property (nonatomic, strong, readonly) PGBaseCollectionView *feedsCollectionView;

@end
