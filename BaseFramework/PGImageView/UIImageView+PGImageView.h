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

@end
