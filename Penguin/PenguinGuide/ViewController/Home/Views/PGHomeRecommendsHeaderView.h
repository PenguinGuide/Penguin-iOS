//
//  PGHomeArticleHeaderView.h
//  Penguin
//
//  Created by Jing Dai on 7/12/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGPagedScrollView.h"

@interface PGHomeRecommendsHeaderView : UICollectionReusableView

@property (nonatomic, strong, readonly) PGPagedScrollView *bannersView;

+ (CGSize)headerViewSize;
- (void)reloadBannersWithData:(NSArray *)dataArray;

@end