//
//  PGSearchResultsHeaderView.h
//  Penguin
//
//  Created by Jing Dai on 8/29/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PGSearchResultsHeaderViewDelegate <NSObject>

- (void)segmentDidClicked:(NSInteger)index;
- (void)cancelButtonClicked;
- (void)backButtonClicked;
- (void)searchButtonClicked:(NSString *)keyword;

@end

@interface PGSearchResultsHeaderView : UIView

@property (nonatomic, weak) id<PGSearchResultsHeaderViewDelegate> delegate;

- (void)setHeaderViewWithKeyword:(NSString *)keyword segments:(NSArray *)segments;

@end
