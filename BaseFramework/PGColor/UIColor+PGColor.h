//
//  UIColor+PGColor.h
//  Penguin
//
//  Created by Jing Dai on 7/1/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (PGColor)

+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor *)whiteColorWithAlpha:(CGFloat)alpha;
+ (UIColor*)blackColorWithAlpha:(CGFloat)alphaValue;

@end
