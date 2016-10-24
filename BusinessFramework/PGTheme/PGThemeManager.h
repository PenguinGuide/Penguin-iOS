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

- (UIFont *)fontExtraSmall;
- (UIFont *)fontSmall;
- (UIFont *)fontMedium;
- (UIFont *)fontLarge;
- (UIFont *)fontExtraLarge;

- (UIFont *)fontExtraSmallBold;
- (UIFont *)fontSmallBold;
- (UIFont *)fontMediumBold;
- (UIFont *)fontLargeBold;
- (UIFont *)fontExtraLargeBold;

- (NSArray *)loadingImages;

- (UIColor *)colorHighlight;
- (UIColor *)colorExtraHighlight;

- (UIColor *)colorLightGray;
/**
 *  @return 454545
 */
- (UIColor *)colorText;
/**
 *  @return AFAFAF
 */
- (UIColor *)colorLightText;

- (UIColor *)colorBackground;
- (UIColor *)colorLightBackground;

- (UIColor *)colorRed;

- (UIColor *)colorBorder;   // 225
- (UIColor *)colorLightBorder;  // 234

@end
