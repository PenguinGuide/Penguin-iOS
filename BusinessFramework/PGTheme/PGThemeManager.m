//
//  PGTheme.m
//  Penguin
//
//  Created by Jing Dai on 6/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

static UIFont *fontSize12, *fontSize14, *fontSize16;
static NSArray *loadingImages;
static UIColor *colorHighlight;

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
        fontSize12 = [UIFont systemFontOfSize:12.f weight:UIFontWeightLight];
        fontSize14 = [UIFont systemFontOfSize:14.f weight:UIFontWeightLight];
        fontSize16 = [UIFont systemFontOfSize:16.f weight:UIFontWeightLight];
        
        colorHighlight = [UIColor colorWithRed:239.f/256.f green:103.f/256.f blue:51.f/256.f alpha:1.f];
        
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
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"pg_navigation_bg_image"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageRenderingModeAlwaysOriginal] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
}

- (NSArray *)loadingImages
{
    if (self.themeStyle == PGThemeStyleDefault) {
        return loadingImages;
    } else {
        return loadingImages;
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

- (UIColor *)colorHighlight
{
    if (self.themeStyle == PGThemeStyleDefault) {
        return colorHighlight;
    } else {
        return colorHighlight;
    }
}

@end
