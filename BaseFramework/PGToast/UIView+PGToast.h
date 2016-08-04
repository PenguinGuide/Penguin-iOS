//
//  UIView+PGToast.h
//  Penguin
//
//  Created by Jing Dai on 8/1/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PGToastPosition) {
    PGToastPositionTop,
    PGToastPositionCenter,
    PGToastPositionBottom
};

@interface PGToastStyle : NSObject

@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) CGFloat textPadding;

@property (nonatomic, strong) UIColor *toastBackgroundColor;
@property (nonatomic, strong) UIColor *toastBorderColor;
@property (nonatomic, assign) CGFloat toastBorderWidth;
@property (nonatomic, assign) CGFloat toastBorderRadius;

@end

@class PGToastStyle;

@interface UIView (PGToast)

- (void)showToast:(NSString *)message;
- (void)showToast:(NSString *)message position:(PGToastPosition)position; 
- (void)showToast:(NSString *)message position:(PGToastPosition)position styleConfig:(void(^)(PGToastStyle *style))styleConfig;

@end
