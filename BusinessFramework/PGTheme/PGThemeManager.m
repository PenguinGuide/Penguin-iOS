//
//  PGTheme.m
//  Penguin
//
//  Created by Jing Dai on 6/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

static UIFont *fontSize12, *fontSize14, *fontSize16;

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
        
        [self initAppearance];
    }
    
    return self;
}

- (void)initAppearance
{
    //[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithWhite:1.0 alpha:0.4]];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"pg_navigation_back_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 12, 0, 0)]
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
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

@end
