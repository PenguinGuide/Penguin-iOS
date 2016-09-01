//
//  PGStoreRecommendsHeaderView.h
//  Penguin
//
//  Created by Jing Dai on 8/31/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGPagedScrollView.h"

@interface PGStoreRecommendsHeaderView : UICollectionReusableView

@property (nonatomic, strong, readonly) PGPagedScrollView *bannersView;

+ (CGSize)headerViewSize;
- (void)reloadBannersWithData:(NSArray *)dataArray;

@end
