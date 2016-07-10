//
//  PGTourView.h
//  Penguin
//
//  Created by Jing Dai on 7/6/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGPagedScrollView.h"

@interface PGTourView : UIView

@property (nonatomic, strong, readonly) PGPagedScrollView *pagedScrollView;
@property (nonatomic, strong, readonly) UIButton *registerButton;
@property (nonatomic, strong, readonly) UIButton *loginButton;

@end
