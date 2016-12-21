//
//  UIImageView+PGImageView.h
//  Penguin
//
//  Created by Jing Dai on 6/30/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (PGImageView)

- (void)setWithImageURL:(NSString *)imageURL placeholder:(UIImage *)placeholder completion:(void(^)(UIImage *image))completion;

- (void)setBlurEffect;
- (void)setLightBlurEffectWithAlpha:(CGFloat)alpha;
- (void)setDarkBlurEffectWithAlpha:(CGFloat)alpha;
- (void)setExtraLightBlurEffectWithAlpha:(CGFloat)alpha;
- (void)setBlurEffectWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

@end
