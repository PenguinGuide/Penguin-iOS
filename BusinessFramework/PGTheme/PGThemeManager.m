//
//  PGTheme.m
//  Penguin
//
//  Created by Jing Dai on 6/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

static UIFont *fontSize10, *fontSize12, *fontSize14, *fontSize16, *fontSize18;
static UIFont *fontSize10Bold, *fontSize12Bold, *fontSize14Bold, *fontSize16Bold, *fontSize18Bold;
static NSArray *loadingImages;
static UIColor *colorHighlight, *colorExtraHighlight, *colorLightGray, *colorText, *colorLightText, *colorBackground, *colorLightBackground;
static UIColor *colorBorder, *colorLightBorder;

#import "PGThemeManager.h"

@implementation PGThemeManager

+ (PGThemeManager *)sharedManager
{
    static PGThemeManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[PGThemeManager alloc] init];
    });
    
    return sharedManager;
}

- (id)init
{
    if (self = [super init]) {
        fontSize10 = [UIFont systemFontOfSize:10.f weight:UIFontWeightLight];
        fontSize12 = [UIFont systemFontOfSize:12.f weight:UIFontWeightLight];
        fontSize14 = [UIFont systemFontOfSize:14.f weight:UIFontWeightLight];
        fontSize16 = [UIFont systemFontOfSize:16.f weight:UIFontWeightLight];
        fontSize18 = [UIFont systemFontOfSize:18.f weight:UIFontWeightLight];
        
        fontSize10Bold = [UIFont systemFontOfSize:10.f weight:UIFontWeightMedium];
        fontSize12Bold = [UIFont systemFontOfSize:12.f weight:UIFontWeightMedium];
        fontSize14Bold = [UIFont systemFontOfSize:14.f weight:UIFontWeightMedium];
        fontSize16Bold = [UIFont systemFontOfSize:16.f weight:UIFontWeightMedium];
        fontSize18Bold = [UIFont systemFontOfSize:18.f weight:UIFontWeightMedium];
        
        colorHighlight = [UIColor colorWithRed:241.f/256.f green:149.f/256.f blue:114.f/256.f alpha:1.f];
        colorExtraHighlight = [UIColor colorWithRed:239.f/256.f green:103.f/256.f blue:51.f/256.f alpha:1.f];
        colorText = [UIColor colorWithRed:69.f/256.f green:69.f/256.f blue:69.f/256.f alpha:1.f];
        colorLightText = [UIColor colorWithRed:175.f/256.f green:175.f/256.f blue:175.f/256.f alpha:1.f];
        colorBackground = [UIColor colorWithRed:241.f/256.f green:241.f/256.f blue:241.f/256.f alpha:1.f];
        colorLightBackground = [UIColor colorWithRed:248.f/256.f green:248.f/256.f blue:248.f/256.f alpha:1.f];
        
        colorBorder = [UIColor colorWithRed:225.f/256.f green:225.f/256.f blue:225.f/256.f alpha:1.f];
        colorLightBorder = [UIColor colorWithRed:234.f/256.f green:234.f/256.f blue:234.f/256.f alpha:1.f];
        
        loadingImages = @[[UIImage imageNamed:@"pg_pull_loading_00"],
                          [UIImage imageNamed:@"pg_pull_loading_01"],
                          [UIImage imageNamed:@"pg_pull_loading_02"],
                          [UIImage imageNamed:@"pg_pull_loading_03"],
                          [UIImage imageNamed:@"pg_pull_loading_04"],
                          [UIImage imageNamed:@"pg_pull_loading_05"],
                          [UIImage imageNamed:@"pg_pull_loading_06"],
                          [UIImage imageNamed:@"pg_pull_loading_07"],
                          [UIImage imageNamed:@"pg_pull_loading_08"],
                          [UIImage imageNamed:@"pg_pull_loading_09"],
                          [UIImage imageNamed:@"pg_pull_loading_10"],
                          [UIImage imageNamed:@"pg_pull_loading_11"],
                          [UIImage imageNamed:@"pg_pull_loading_12"],
                          [UIImage imageNamed:@"pg_pull_loading_13"],
                          [UIImage imageNamed:@"pg_pull_loading_14"],
                          [UIImage imageNamed:@"pg_pull_loading_15"],
                          [UIImage imageNamed:@"pg_pull_loading_16"],
                          [UIImage imageNamed:@"pg_pull_loading_17"],
                          [UIImage imageNamed:@"pg_pull_loading_18"],
                          [UIImage imageNamed:@"pg_pull_loading_19"],
                          [UIImage imageNamed:@"pg_pull_loading_20"],
                          [UIImage imageNamed:@"pg_pull_loading_21"],
                          [UIImage imageNamed:@"pg_pull_loading_22"],
                          [UIImage imageNamed:@"pg_pull_loading_23"],
                          [UIImage imageNamed:@"pg_pull_loading_24"],
                          [UIImage imageNamed:@"pg_pull_loading_25"],
                          [UIImage imageNamed:@"pg_pull_loading_26"],
                          [UIImage imageNamed:@"pg_pull_loading_27"],
                          [UIImage imageNamed:@"pg_pull_loading_28"],
                          [UIImage imageNamed:@"pg_pull_loading_29"],
                          [UIImage imageNamed:@"pg_pull_loading_30"],
                          [UIImage imageNamed:@"pg_pull_loading_31"],
                          [UIImage imageNamed:@"pg_pull_loading_32"],
                          [UIImage imageNamed:@"pg_pull_loading_33"],
                          [UIImage imageNamed:@"pg_pull_loading_34"]];
        
        [self initAppearance];
    }
    
    return self;
}

- (void)initAppearance
{
    // http://blog.csdn.net/G_eorge/article/details/51144017 navigation bar translucent
    //[[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
//    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"pg_navigation_bg_image"] resizableImageWithCapInsets:UIEdgeInsetsZero]
//                                      forBarPosition:UIBarPositionAny
//                                          barMetrics:UIBarMetricsDefault];
}

- (NSArray *)loadingImages
{
    if (self.themeStyle == PGThemeStyleDefault) {
        return loadingImages;
    } else {
        return loadingImages;
    }
}

- (UIFont *)fontExtraSmall
{
    if (self.themeStyle == PGThemeStyleDefault) {
        return fontSize10;
    } else {
        return fontSize10;
    }
}

- (UIFont *)fontSmall
{
    if (self.themeStyle == PGThemeStyleDefault) {
        return fontSize12;
    } else {
        return fontSize12;
    }
}

- (UIFont *)fontMedium
{
    if (self.themeStyle == PGThemeStyleDefault) {
        return fontSize14;
    } else {
        return fontSize14;
    }
}

- (UIFont *)fontLarge
{
    if (self.themeStyle == PGThemeStyleDefault) {
        return fontSize16;
    } else {
        return fontSize16;
    }
}

- (UIFont *)fontExtraLarge
{
    if (self.themeStyle == PGThemeStyleDefault) {
        return fontSize18;
    } else {
        return fontSize18;
    }
}

- (UIFont *)fontExtraSmallBold
{
    if (self.themeStyle == PGThemeStyleDefault) {
        return fontSize10Bold;
    } else {
        return fontSize10Bold;
    }
}

- (UIFont *)fontSmallBold
{
    if (self.themeStyle == PGThemeStyleDefault) {
        return fontSize12Bold;
    } else {
        return fontSize12Bold;
    }
}

- (UIFont *)fontMediumBold
{
    if (self.themeStyle == PGThemeStyleDefault) {
        return fontSize14Bold;
    } else {
        return fontSize14Bold;
    }
}

- (UIFont *)fontLargeBold
{
    if (self.themeStyle == PGThemeStyleDefault) {
        return fontSize16Bold;
    } else {
        return fontSize16Bold;
    }
}

- (UIFont *)fontExtraLargeBold
{
    if (self.themeStyle == PGThemeStyleDefault) {
        return fontSize18Bold;
    } else {
        return fontSize18Bold;
    }
}

- (UIColor *)colorHighlight
{
    if (self.themeStyle == PGThemeStyleDefault) {
        return colorHighlight;
    } else {
        return colorHighlight;
    }
}

- (UIColor *)colorExtraHighlight
{
    if (self.themeStyle == PGThemeStyleDefault) {
        return colorExtraHighlight;
    } else {
        return colorExtraHighlight;
    }
}

- (UIColor *)colorLightGray
{
    if (self.themeStyle == PGThemeStyleDefault) {
        return colorLightGray;
    } else {
        return colorLightGray;
    }
}

- (UIColor *)colorText
{
    if (self.themeStyle == PGThemeStyleDefault) {
        return colorText;
    } else {
        return colorText;
    }
}

- (UIColor *)colorLightText
{
    if (self.themeStyle == PGThemeStyleDefault) {
        return colorLightText;
    } else {
        return colorLightText;
    }
}

- (UIColor *)colorBackground
{
    if (self.themeStyle == PGThemeStyleDefault) {
        return colorBackground;
    } else {
        return colorBackground;
    }
}

- (UIColor *)colorLightBackground
{
    if (self.themeStyle == PGThemeStyleDefault) {
        return colorLightBackground;
    } else {
        return colorLightBackground;
    }
}

- (UIColor *)colorBorder
{
    if (self.themeStyle == PGThemeStyleDefault) {
        return colorBorder;
    } else {
        return colorBorder;
    }
}

- (UIColor *)colorLightBorder
{
    if (self.themeStyle == PGThemeStyleDefault) {
        return colorLightBorder;
    } else {
        return colorLightBorder;
    }
}

@end
