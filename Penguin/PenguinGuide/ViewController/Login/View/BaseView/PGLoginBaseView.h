//
//  PGLoginBaseView.h
//  Penguin
//
//  Created by Jing Dai on 7/6/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PGLoginBaseView;

@protocol PGLoginViewDelegate <NSObject>

@optional

- (void)backButtonClicked:(PGLoginBaseView *)view;

@end

@interface PGLoginBaseView : UIView

@property (nonatomic, weak) id<PGLoginViewDelegate> delegate;

@property (nonatomic, strong, readonly) UIButton *backButton;
@property (nonatomic, strong, readonly) UIImageView *logoView;

@end
