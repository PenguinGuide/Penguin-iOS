//
//  PGExploreRecommendsHeaderView.h
//  Penguin
//
//  Created by Jing Dai on 8/29/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGPagedScrollView.h"

@interface PGExploreRecommendsHeaderView : UICollectionReusableView

@property (nonatomic, strong, readonly) PGPagedScrollView *bannersView;

+ (CGSize)headerViewSize;
- (void)reloadBannersWithRecommendsArray:(NSArray *)recommendsArray;

@end
