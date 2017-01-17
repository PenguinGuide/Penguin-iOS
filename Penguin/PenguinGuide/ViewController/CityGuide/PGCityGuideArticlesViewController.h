//
//  PGCityGuideArticlesViewController.h
//  Penguin
//
//  Created by Jing Dai on 28/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewController.h"

@interface PGCityGuideArticlesViewController : PGBaseViewController

@property (nonatomic, strong, readonly) PGBaseCollectionView *articlesCollectionView;

- (id)initWithCityId:(NSString *)cityId;

@end