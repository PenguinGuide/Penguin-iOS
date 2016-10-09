//
//  PGArticleParagraphVideoCell.m
//  Penguin
//
//  Created by Jing Dai on 9/20/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGArticleParagraphVideoCell.h"

@interface PGArticleParagraphVideoCell ()

@property (nonatomic, strong) UIImageView *videoImageView;

@end

@implementation PGArticleParagraphVideoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    [self.contentView addSubview:self.videoImageView];
}

- (void)setCellWithImage:(NSString *)image
{
    self.videoImageView.frame = CGRectMake(0, 20, self.pg_width, self.pg_height-40);
    [self.videoImageView setWithImageURL:image placeholder:nil completion:nil];
}

- (UIImageView *)videoImageView
{
    if (!_videoImageView) {
        _videoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, self.pg_width, self.pg_height-40)];
        _videoImageView.clipsToBounds = YES;
        _videoImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _videoImageView;
}

@end
