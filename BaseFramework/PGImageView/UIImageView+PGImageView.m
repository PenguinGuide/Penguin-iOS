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

@end
