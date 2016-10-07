//
//  PGMeHeaderView.h
//  Penguin
//
//  Created by Jing Dai on 23/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGMe.h"

@interface PGMeHeaderView : UICollectionReusableView

@property (nonatomic, strong) UIButton *avatarButton;
@property (nonatomic, strong) UIButton *settingButton;

- (void)setViewWithMe:(PGMe *)me;

+ (CGSize)headerViewSize;

@end
