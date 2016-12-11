//
//  FLAnimatedImageView+PGAnimatedImageView.m
//  Penguin
//
//  Created by Jing Dai on 7/28/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "FLAnimatedImageView+PGAnimatedImageView.h"
#import <SDWebImage/SDWebImageDownloader.h>
//#import "FLAnimatedImageView+WebCache.h"

@implementation FLAnimatedImageView (PGAnimatedImageView)

- (void)setWithImageURL:(NSString *)imageURL placeholder:(UIImage *)placeholder completion:(void (^)(UIImage *image))completion
{
    CGSize imageSize = self.frame.size;
    NSString *cropQuery = @"";
    
    if ([self isSmallScreen]) {
        if (CGSizeEqualToSize(imageSize, CGSizeZero)) {
            cropQuery = @"?imageView2/0/w/750/h/750";
        } else {
            cropQuery = [NSString stringWithFormat:@"?imageView2/0/w/%@/h/%@", @((int)imageSize.width), @((int)imageSize.height)];
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
    
    __weak typeof(self) weakSelf = self;
//    [self sd_setImageWithURL:[NSURL URLWithString:imageURL]
//            placeholderImage:placeholder
//                   completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//                       
//                   }];
    
//    [self sd_setImageWithURL:[NSURL URLWithString:imageURL]
//            placeholderImage:placeholder
//                   completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//                       [[SDImageCache sharedImageCache] queryCacheOperationForKey:imageURL
//                                                                             done:^(UIImage * _Nullable image, NSData * _Nullable data, SDImageCacheType cacheType) {
//                                                                                 FLAnimatedImage *animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];
//                                                                                 weakSelf.animatedImage = animatedImage;
//                                                                             }];
//                   }];
    
//    __weak typeof(self) weakSelf = self;
//    
//    // https://yq.aliyun.com/articles/28145
//    
//    NSString *path = [[[SDWebImageManager sharedManager] imageCache] defaultCachePathForKey:imageURL];
//    NSData *gifData = [NSData dataWithContentsOfFile:path];
//    
//    if (gifData) {
//        FLAnimatedImage *animatedImage = [FLAnimatedImage animatedImageWithGIFData:gifData];
//        self.animatedImage = animatedImage;
//    } else {
//        
//
//        
//        
////        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageURL]
////                                                              options:SDWebImageDownloaderHighPriority
////                                                             progress:nil
////                                                            completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
////                                                                [[[SDWebImageManager sharedManager] imageCache] storeImage:image
////                                                                                                      recalculateFromImage:NO
////                                                                                                                 imageData:data
////                                                                                                                    forKey:imageURL
////                                                                                                                    toDisk:YES];
////                                                                dispatch_async(dispatch_get_main_queue(), ^{
//                                                                    FLAnimatedImage *animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];
//                                                                    weakSelf.animatedImage = animatedImage;
////                                                                });
////                                                            }];
//    }

}

- (void)setStaticImageURL:(NSString *)imageURL placeholder:(UIImage *)placeholder completion:(void (^)(UIImage *image))completion
{
    CGSize imageSize = self.frame.size;
    NSString *cropQuery = @"";
    
    if ([self isSmallScreen]) {
        if (CGSizeEqualToSize(imageSize, CGSizeZero)) {
            cropQuery = @"?imageView2/0/w/750/h/750";
        } else {
            cropQuery = [NSString stringWithFormat:@"?imageView2/0/w/%@/h/%@", @((int)imageSize.width), @((int)imageSize.height)];
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
    __weak typeof(self) weakSelf = self;
//    [self sd_setImageWithURL:[NSURL URLWithString:imageURL]
//            placeholderImage:placeholder
//                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                       weakSelf.image = image;
//                       if (completion) {
//                           completion(nil);
//                       }
//                   }];
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
