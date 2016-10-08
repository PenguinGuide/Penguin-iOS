//
//  PGArticleParagraphGIFImageCell.m
//  Penguin
//
//  Created by Jing Dai on 7/28/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGArticleParagraphGIFImageCell.h"
#import "FLAnimatedImageView+PGAnimatedImageView.h"

@interface PGArticleParagraphGIFImageCell ()

@property (nonatomic, strong) FLAnimatedImageView *imageView;

@end

@implementation PGArticleParagraphGIFImageCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    
    return self;
}

- (void)initialize
{
    [self.contentView addSubview:self.imageView];
}

- (void)setCellWithImage:(NSString *)image
{
    self.imageView.frame = CGRectMake(0, 20, self.width, self.height-40);
    [self.imageView setWithImageURL:image placeholder:nil completion:nil];
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(0, 20, self.width, self.height-40)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

@end
