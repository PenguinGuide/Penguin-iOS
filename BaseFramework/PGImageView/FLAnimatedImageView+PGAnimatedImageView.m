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
