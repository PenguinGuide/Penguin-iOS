//
//  PGChannelAllCategoriesHeaderView.h
//  Penguin
//
//  Created by Jing Dai on 8/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGChannel.h"

@interface PGChannelAllCategoriesHeaderView : UICollectionReusableView

- (void)setViewWithChannel:(PGChannel *)channel;
+ (CGSize)viewSize:(PGChannel *)channel;

@end
