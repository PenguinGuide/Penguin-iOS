//
//  UINavigationBar+PGTransparentNaviBar.h
//  Penguin
//
//  Created by Jing Dai on 8/23/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (PGTransparentNaviBar)

- (void)pg_setBackgroundColor:(UIColor *)backgroundColor;
- (void)pg_setElementsAlpha:(CGFloat)alpha;
- (void)pg_setTranslationY:(CGFloat)translationY;
- (void)pg_reset;

@end
