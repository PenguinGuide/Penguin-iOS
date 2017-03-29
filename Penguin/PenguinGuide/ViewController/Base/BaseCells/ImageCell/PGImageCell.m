//
//  PGImageCell.m
//  Penguin
//
//  Created by Kobe Dai on 29/03/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import "PGImageCell.h"

@interface PGImageCell ()

@property (nonatomic, strong) UIImageView *cellImageView;

@end

@implementation PGImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)setCellWithImage:(UIImage *)image
{
    self.cellImageView.image = image;
}

- (void)moreCellDidSelectWithLink:(NSString *)link
{
    [[PGRouter sharedInstance] openURL:link];
}

- (void)initialize
{
    [self.contentView addSubview:self.cellImageView];
}

- (UIImageView *)cellImageView
{
    if (!_cellImageView) {
        _cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, self.pg_height)];
    }
    return _cellImageView;
}

@end
