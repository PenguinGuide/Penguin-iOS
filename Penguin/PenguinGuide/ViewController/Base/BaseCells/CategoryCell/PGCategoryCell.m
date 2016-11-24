//
//  PGCategoryCell.m
//  Penguin
//
//  Created by Jing Dai on 23/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGCategoryCell.h"

@interface PGCategoryCell ()

@property (nonatomic, strong) UIImageView *categoryImageView;
@property (nonatomic, strong) UILabel *categoryTitleLabel;

@end

@implementation PGCategoryCell

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
    [self.contentView addSubview:self.categoryTitleLabel];
    
    UIImageView *maskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.categoryImageView.pg_width, self.categoryImageView.pg_height)];
    maskImageView.image = [[UIImage imageNamed:@"pg_bg_corner_mask"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4) resizingMode:UIImageResizingModeStretch];
    [self.contentView addSubview:maskImageView];
}

- (void)setCellWithCategoryIcon:(PGCategoryIcon *)icon
{
    [self.categoryImageView setWithImageURL:icon.image placeholder:nil completion:nil];
    [self.categoryTitleLabel setText:icon.title];
}

+ (CGSize)cellSize
{
    return CGSizeMake(120, 80+35);
}

- (UIImageView *)categoryImageView
{
    if (!_categoryImageView) {
        _categoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, self.pg_height-35)];
        _categoryImageView.clipsToBounds = YES;
        _categoryImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _categoryImageView;
}

- (UILabel *)categoryTitleLabel
{
    if (!_categoryTitleLabel) {
        _categoryTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, self.categoryImageView.pg_bottom+15, self.pg_width, 16)];
        _categoryTitleLabel.font = Theme.fontMediumBold;
        _categoryTitleLabel.textColor = Theme.colorText;
    }
    return _categoryTitleLabel;
}

@end
