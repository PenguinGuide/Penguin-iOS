//
//  PGTheme.h
//  Penguin
//
//  Created by Jing Dai on 6/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

typedef NS_ENUM(NSInteger, PGThemeStyle) {
    PGThemeStyleDefault,
    PGThemeStyleSpecial
};

#define Theme [PGThemeManager sharedManager]

#import <Foundation/Foundation.h>

@interface PGThemeManager : NSObject

@property (nonatomic) PGThemeStyle themeStyle;

+ (PGThemeManager *)sharedManager;

- (UIFont *)fontSmall;
- (UIFont *)fontMedium;
- (UIFont *)fontLarge;

@end
