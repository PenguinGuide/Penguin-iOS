//
//  UIView+PGToast.m
//  Penguin
//
//  Created by Jing Dai on 8/1/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

static char ToastLabel;
static char ToastTimer;

#import "UIView+PGToast.h"
#import <objc/runtime.h>

@interface UIView ()

@property (nonatomic, strong) UILabel *toastLabel;
@property (nonatomic, strong) NSTimer *toastTimer;

@end

@implementation UIView (PGToast)

- (void)showToast:(NSString *)message
{
    [self showToast:message position:PGToastPositionBottom styleConfig:^(PGToastStyle *style) {
        style.textFont = [UIFont systemFontOfSize:16.f weight:UIFontWeightLight];
        style.textColor = [UIColor blackColor];
        style.textPadding = 5.f;
        style.toastBackgroundColor = [UIColor colorWithWhite:1.f alpha:0.8f];
        style.toastBorderColor = [UIColor blackColor];
        style.toastBorderWidth = 1.f;
        style.toastBorderRadius = 4.f;
    }];
}

- (void)showToast:(NSString *)message position:(PGToastPosition)position
{
    [self showToast:message position:position styleConfig:^(PGToastStyle *style) {
        style.textFont = [UIFont systemFontOfSize:16.f weight:UIFontWeightLight];
        style.textColor = [UIColor blackColor];
        style.textPadding = 5.f;
        style.toastBackgroundColor = [UIColor colorWithWhite:1.f alpha:0.8f];
        style.toastBorderColor = [UIColor blackColor];
        style.toastBorderWidth = 1.f;
        style.toastBorderRadius = 4.f;
    }];
}

- (void)showToast:(NSString *)message position:(PGToastPosition)position styleConfig:(void (^)(PGToastStyle *style))styleConfig
{
    if (message && message.length > 0) {
        PGToastStyle *style = [[PGToastStyle alloc] init];
        styleConfig(style);
        
        if (!self.toastLabel) {
            UILabel *toastLabel = [[UILabel alloc] init];
            objc_setAssociatedObject(self, &ToastLabel, toastLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        
        self.toastLabel.text = message;
        self.toastLabel.textAlignment = NSTextAlignmentCenter;
        
        if (style.textColor) {
            self.toastLabel.font = style.textFont;
        } else {
            self.toastLabel.font = [UIFont systemFontOfSize:14.f weight:UIFontWeightLight];
        }
        
        if (style.textColor) {
            self.toastLabel.textColor = style.textColor;
        } else {
            self.toastLabel.textColor = [UIColor blackColor];
        }
        
        if (style.toastBackgroundColor) {
            self.toastLabel.backgroundColor = style.toastBackgroundColor;
        } else {
            self.toastLabel.backgroundColor = [UIColor whiteColor];
        }
        
        if (style.toastBorderWidth > 0.f && style.toastBorderColor) {
            self.toastLabel.layer.borderWidth = style.toastBorderWidth;
            self.toastLabel.layer.borderColor = style.toastBorderColor.CGColor;
            
            if (style.toastBorderRadius > 0.f) {
                self.toastLabel.clipsToBounds = YES;
                self.toastLabel.layer.cornerRadius = style.toastBorderRadius;
            }
        }
        
        CGFloat labelWidth = [message sizeWithAttributes:@{NSFontAttributeName:self.toastLabel.font}].width + 25;
        CGFloat labelHeight = 35.f;
        CGFloat labelX = ([UIScreen mainScreen].bounds.size.width-labelWidth)/2;
        
        if (position == PGToastPositionTop) {
            self.toastLabel.frame = CGRectMake(labelX, 64+10, labelWidth, labelHeight);
        } else if (position == PGToastPositionCenter) {
            self.toastLabel.frame = CGRectMake(labelX, (self.frame.size.height-labelHeight)/2-labelHeight/2, labelWidth, labelHeight);
        } else {
            self.toastLabel.frame = CGRectMake(labelX, self.frame.size.height-80-labelHeight, labelWidth, labelHeight);
        }
        
        [self.toastLabel removeFromSuperview];
        self.toastLabel.alpha = 0.f;
        [self addSubview:self.toastLabel];
        
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.4f
                         animations:^{
                             weakSelf.toastLabel.alpha = 1.f;
                         } completion:^(BOOL finished) {
                             if (weakSelf.toastTimer) {
                                 [weakSelf.toastTimer invalidate];
                             }
                             NSTimer *timer = [NSTimer timerWithTimeInterval:2.f target:weakSelf selector:@selector(hideToastLabel) userInfo:nil repeats:NO];
                             [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
                             objc_setAssociatedObject(weakSelf, &ToastTimer, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                         }];
    }
}

- (void)hideToastLabel
{
    if (self.toastLabel) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.4f
                              delay:0.f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             weakSelf.toastLabel.alpha = 0.f;
                         } completion:^(BOOL finished) {
                             [weakSelf.toastTimer invalidate];
                             [weakSelf.toastLabel removeFromSuperview];
                         }];
    }
}

- (UILabel *)toastLabel {
    return objc_getAssociatedObject(self, &ToastLabel);
}

- (NSTimer *)toastTimer
{
    return objc_getAssociatedObject(self, &ToastTimer);
}

@end
