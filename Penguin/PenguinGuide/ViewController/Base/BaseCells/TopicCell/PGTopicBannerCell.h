//
//  PGTopicBannerCell.h
//  Penguin
//
//  Created by Jing Dai on 8/24/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGTopicBanner.h"

@interface PGTopicBannerCell : UICollectionViewCell

- (void)setCellWithTopic:(PGTopicBanner *)topic;

+ (CGSize)cellSize;

@end
