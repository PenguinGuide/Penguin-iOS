//
//  PGExploreRecommendsHeaderView.h
//  Penguin
//
//  Created by Jing Dai on 8/29/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGPagedScrollView.h"
#import "PGCategoryIcon.h"

@protocol PGExploreRecommendsHeaderViewDelegate <NSObject>

- (void)scenarioDidSelect:(PGCategoryIcon *)scenario;

@end

@interface PGExploreRecommendsHeaderView : UICollectionReusableView

@property (nonatomic, strong, readonly) PGPagedScrollView *bannersView;
@property (nonatomic, weak) id<PGExploreRecommendsHeaderViewDelegate> delegate;

+ (CGSize)headerViewSize;
- (void)reloadBannersWithRecommendsArray:(NSArray *)recommendsArray scenariosArray:(NSArray *)scenariosArray;

@end
