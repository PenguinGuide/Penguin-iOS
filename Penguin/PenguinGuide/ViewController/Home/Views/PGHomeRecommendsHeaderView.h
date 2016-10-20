//
//  PGHomeArticleHeaderView.h
//  Penguin
//
//  Created by Jing Dai on 7/12/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGPagedScrollView.h"

@protocol PGHomeRecommendsHeaderViewDelegate <NSObject>

- (void)channelDidSelect:(NSString *)channelType;

@end

@interface PGHomeRecommendsHeaderView : UICollectionReusableView

@property (nonatomic, strong, readonly) PGPagedScrollView *bannersView;
@property (nonatomic, weak) id<PGHomeRecommendsHeaderViewDelegate> delegate;

+ (CGSize)headerViewSize;
- (void)reloadBannersWithRecommendsArray:(NSArray *)recommendsArray channelsArray:(NSArray *)channelsArray;

@end
