//
//  PGSearchRecommendsHistoryHeaderView.h
//  Penguin
//
//  Created by Jing Dai on 8/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PGSearchRecommendsHistoryHeaderViewDelegate <NSObject>

- (void)historyDeleteButtonClicked;

@end

@interface PGSearchRecommendsHistoryHeaderView : UICollectionReusableView

@property (nonatomic, weak) id<PGSearchRecommendsHistoryHeaderViewDelegate> delegate;

@end
