//
//  PGTheme.h
//  Penguin
//
//  Created by Jing Dai on 6/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define Theme [PGThemeManager sharedManager]

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PGThemeStyle) {
    PGThemeStyleDefault,
    PGThemeStyleSpecial
};

@interface PGThemeManager : NSObject

@property (nonatomic) PGThemeStyle themeStyle;

+ (PGThemeManager *)sharedManager;

- (UIFont *)fontSmall;
- (UIFont *)fontMedium;
- (UIFont *)fontLarge;
- (NSArray *)loadingImages;

- (UIColor *)colorHighlight;
- (UIColor *)colorDarkGray;
- (UIColor *)colorGray;
- (UIColor *)colorLightGray;

@end
