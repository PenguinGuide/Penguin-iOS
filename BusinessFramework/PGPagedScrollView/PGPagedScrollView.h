//
//  PGPagedScrollView.h
//  Penguin
//
//  Created by Jing Dai on 7/6/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PGPagedScrollViewDelegate <NSObject>

- (NSArray *)imagesForScrollView;

@end

@interface PGPagedScrollView : UIView

@property (nonatomic, weak) id<PGPagedScrollViewDelegate> delegate;

- (void)reloadData;

@end
