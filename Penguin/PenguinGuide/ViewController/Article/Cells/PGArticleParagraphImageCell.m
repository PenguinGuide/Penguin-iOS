//
//  PGArticleParagraphImageCell.m
//  Penguin
//
//  Created by Jing Dai on 7/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGArticleParagraphImageCell.h"

@interface PGArticleParagraphImageCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation PGArticleParagraphImageCell

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
    self.imageView.frame = CGRectMake(0, 20, self.pg_width, self.pg_height-40);
    [self.imageView setWithImageURL:image placeholder:PGImageViewPlaceholder completion:nil];
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, self.pg_width, self.pg_height-40)];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

@end
