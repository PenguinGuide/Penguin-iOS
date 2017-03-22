//
//  PGNavigationView.h
//  Penguin
//
//  Created by Jing Dai on 30/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PGNavigationViewDelegate <NSObject>

@optional

- (void)searchButtonClicked;
- (void)naviBackButtonClicked;

@end

@interface PGNavigationView : UIView

@property (nonatomic, weak) id<PGNavigationViewDelegate> delegate;

+ (PGNavigationView *)defaultNavigationView;
+ (PGNavigationView *)defaultNavigationViewWithSearchButton;
+ (PGNavigationView *)naviViewWithBackButton:(NSString *)naviTitle;

@end
