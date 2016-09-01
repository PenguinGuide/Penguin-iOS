//
//  PGSegmentView.h
//  Penguin
//
//  Created by Jing Dai on 8/29/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PGSegmentViewDelegate <NSObject>

- (void)segmentDidClicked:(NSInteger)index;

@end

@interface PGSegmentView : UIView

@property (nonatomic, weak) id<PGSegmentViewDelegate> delegate;

- (void)setViewWithSegments:(NSArray *)segments;

@end
