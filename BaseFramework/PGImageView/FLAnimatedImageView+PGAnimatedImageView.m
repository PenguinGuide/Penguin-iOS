//
//  FLAnimatedImageView+PGAnimatedImageView.m
//  Penguin
//
//  Created by Jing Dai on 7/28/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "FLAnimatedImageView+PGAnimatedImageView.h"
#import <SDWebImage/SDWebImageDownloader.h>
#import <SDWebImage/UIImageView+WebCache.h>

@implementation FLAnimatedImageView (PGAnimatedImageView)

- (void)setWithImageURL:(NSString *)imageURL placeholder:(UIImage *)placeholder completion:(void (^)(UIImage *))completion
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.width == 375.f) {
        imageURL = [imageURL stringByAppendingString:@"?imageView2/2/w/1000/h/1000"];
    } else if (screenBounds.size.width > 375.f) {
        imageURL = [imageURL stringByAppendingString:@"?imageView2/2/w/1500/h/1500"];
    } else {
        imageURL = [imageURL stringByAppendingString:@"?imageView2/2/w/750/h/750"];
    }
    __weak typeof(self) weakSelf = self;
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageURL]
                                                          options:SDWebImageDownloaderHighPriority
                                                         progress:nil
                                                        completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                            FLAnimatedImage *animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];
                                                            weakSelf.animatedImage = animatedImage;
                                                            if (completion) {
                                                                completion(nil);
                                                            }
                                                        }];
}

- (void)setStaticImageURL:(NSString *)imageURL placeholder:(UIImage *)placeholder completion:(void (^)(UIImage *))completion
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.width == 375.f) {
        imageURL = [imageURL stringByAppendingString:@"?imageView2/2/w/1000/h/1000"];
    } else if (screenBounds.size.width > 375.f) {
        imageURL = [imageURL stringByAppendingString:@"?imageView2/2/w/1500/h/1500"];
    } else {
        imageURL = [imageURL stringByAppendingString:@"?imageView2/2/w/750/h/750"];
    }
    __weak typeof(self) weakSelf = self;
    [self sd_setImageWithURL:[NSURL URLWithString:imageURL]
            placeholderImage:placeholder
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       weakSelf.image = image;
                       if (completion) {
                           completion(nil);
                       }
                   }];
}

@end
