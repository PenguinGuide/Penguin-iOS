//
//  PGStoreRecommendsHeaderView.h
//  Penguin
//
//  Created by Jing Dai on 8/31/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGPagedScrollView.h"
#import "PGCategoryIcon.h"

@protocol PGStoreRecommendsHeaderViewDelegate <NSObject>

- (void)categoryDidSelect:(PGCategoryIcon *)categoryIcon;

@end

@interface PGStoreRecommendsHeaderView : UICollectionReusableView

@property (nonatomic, strong, readonly) PGPagedScrollView *bannersView;
@property (nonatomic, weak) id<PGStoreRecommendsHeaderViewDelegate> delegate;

+ (CGSize)headerViewSize;
- (void)reloadBannersWithData:(NSArray *)dataArray categoriesArray:(NSArray *)categoriesArray;

@end
