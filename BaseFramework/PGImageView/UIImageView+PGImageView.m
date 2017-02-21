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
        CGSize imageSize = self.frame.size;
        NSString *cropQuery = @"";
        
        if ([self isSmallScreen]) {
            if (CGSizeEqualToSize(imageSize, CGSizeZero)) {
                cropQuery = @"?imageView2/0/w/750/h/750";
            } else {
                cropQuery = [NSString stringWithFormat:@"?imageView2/0/w/%@/h/%@", @((int)imageSize.width*2), @((int)imageSize.height*2)];
            }
        } else if ([self isMediumScreen]) {
            if (CGSizeEqualToSize(imageSize, CGSizeZero)) {
                cropQuery = @"?imageView2/0/w/1000/h/1000";
            } else {
                cropQuery = [NSString stringWithFormat:@"?imageView2/0/w/%@/h/%@", @((int)(imageSize.width*2.5)), @((int)(imageSize.width*2.5))];
            }
        } else {
            if (CGSizeEqualToSize(imageSize, CGSizeZero)) {
                cropQuery = @"?imageView2/0/w/1500/h/1500";
            } else {
                cropQuery = [NSString stringWithFormat:@"?imageView2/0/w/%@/h/%@", @((int)(imageSize.width*3)), @((int)(imageSize.height*3))];
            }
        }
        
        imageURL = [imageURL stringByAppendingString:cropQuery];
        
        if (placeholder) {
            [self setImage:placeholder];
        }
        
        __weak typeof(self) weakself = self;
        [self sd_setImageWithURL:[NSURL URLWithString:imageURL]
                placeholderImage:placeholder
                       completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                           if (image && cacheType == SDImageCacheTypeNone) {
                               // CATransition: http://blog.csdn.net/mad2man/article/details/17260887
                               CATransition *transition = [CATransition animation];
                               transition.type = kCATransitionFade; // there are other types but this is the nicest
                               transition.duration = 0.3; // set the duration that you like
                               transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                               [weakself.layer addAnimation:transition forKey:nil];
                           }
                           if (completion) {
                               if (!error) {
                                   completion(image);
                               } else {
                                   NSLog(@"image: [%@] download failed, error: [%@]", imageURL.absoluteString, error);
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

- (BOOL)isSmallScreen
{
    // 3.5 & 4.0 inches
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.width < 375.f) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isMediumScreen
{
    // 4.7 inches
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.width == 375.f) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isLargeScreen
{
    // 5.5 inces & iPad
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.width > 375.f) {
        return YES;
    } else {
        return NO;
    }
}

@end
