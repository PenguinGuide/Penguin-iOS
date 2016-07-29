//
//  FLAnimatedImageView+PGAnimatedImageView.h
//  Penguin
//
//  Created by Jing Dai on 7/28/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <FLAnimatedImage/FLAnimatedImage.h>

@interface FLAnimatedImageView (PGAnimatedImageView)

- (void)setWithImageURL:(NSString *)imageURL placeholder:(UIImage *)placeholder completion:(void(^)(UIImage *image))completion;

@end
