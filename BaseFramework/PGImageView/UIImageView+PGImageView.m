//
//  UIImageView+PGImageView.m
//  Penguin
//
//  Created by Jing Dai on 6/30/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "UIImageView+PGImageView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UIImageView (PGImageView)

- (void)setWithImageURL:(NSString *)imageURL placeholder:(UIImage *)placeholder completion:(void (^)(UIImage *))completion
{
    if (imageURL && imageURL.length > 0) {
        imageURL = [imageURL stringByAppendingString:@"?imageView2/2/w/1000/h/1000"];
        [self sd_setImageWithURL:[NSURL URLWithString:imageURL]
                placeholderImage:placeholder
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                           if (completion) {
                               if (!error) {
                                   completion(image);
                               } else {
                                   completion(nil);
                               }
                           }
                       }];
    } else {
        [self setImage:placeholder];
    }
}

- (void)setBlurEffect
{
    [self setLightBlurEffectWithAlpha:0.5f];
}

- (void)setLightBlurEffectWithAlpha:(CGFloat)alpha
{
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = self.frame;
    effectView.alpha = alpha;
    
    [self addSubview:effectView];
}

- (void)setDarkBlurEffectWithAlpha:(CGFloat)alpha
{
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = self.frame;
    effectView.alpha = alpha;
    
    [self addSubview:effectView];
}

- (void)setExtraLightBlurEffectWithAlpha:(CGFloat)alpha
{
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = self.frame;
    effectView.alpha = alpha;
    
    [self addSubview:effectView];
}

@end
