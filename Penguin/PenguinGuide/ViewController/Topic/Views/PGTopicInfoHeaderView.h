//
//  PGTopicHeaderView.h
//  Penguin
//
//  Created by Jing Dai on 14/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGTopicInfoHeaderView : UICollectionReusableView

- (void)setHeaderViewWithImage:(NSString *)image desc:(NSString *)desc;

+ (CGSize)headerViewSize:(NSString *)desc;

@end
