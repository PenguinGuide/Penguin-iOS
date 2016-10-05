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
    self.imageView.frame = CGRectMake(0, 20, self.width, self.height-40);
    [self.imageView setWithImageURL:image placeholder:nil completion:nil];
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, self.width, self.height-40)];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.backgroundColor = Theme.colorText;
    }
    return _imageView;
}

@end
