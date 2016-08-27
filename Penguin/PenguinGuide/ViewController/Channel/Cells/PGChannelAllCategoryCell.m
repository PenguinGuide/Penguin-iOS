//
//  PGChannelAllCategoryCell.m
//  Penguin
//
//  Created by Jing Dai on 8/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGChannelAllCategoryCell.h"

@interface PGChannelAllCategoryCell ()

@property (nonatomic, strong) UIImageView *categoryImageView;

@end

@implementation PGChannelAllCategoryCell

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
    [self.contentView addSubview:self.categoryImageView];
}

- (void)setCellWithCategory:(PGChannelCategory *)category
{
    [self.categoryImageView setWithImageURL:category.image placeholder:nil completion:nil];
}

+ (CGSize)cellSize
{
    CGFloat width = (UISCREEN_WIDTH-15)/2;
    return CGSizeMake(width, width*45/80);
}

- (UIImageView *)categoryImageView {
    if(_categoryImageView == nil) {
        _categoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _categoryImageView.backgroundColor = Theme.colorBackground;
        _categoryImageView.clipsToBounds = YES;
        _categoryImageView.layer.cornerRadius = 10.f;
    }
    return _categoryImageView;
}

@end
