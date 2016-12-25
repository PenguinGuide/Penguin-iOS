//
//  PGChannelCategoryCell.m
//  Penguin
//
//  Created by Jing Dai on 8/26/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGChannelCategoryCell.h"

@interface PGChannelCategoryCell ()

@property (nonatomic, strong) UIImageView *categoryImageView;
@property (nonatomic, strong) UIView *dimView;
@property (nonatomic, strong) UIView *horizontalLine;

@end

@implementation PGChannelCategoryCell

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
    self.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:self.categoryImageView];
    [self.contentView addSubview:self.dimView];
    [self.contentView addSubview:self.horizontalLine];
    
    UIImageView *maskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, self.pg_height-8)];
    maskImageView.image = [[UIImage imageNamed:@"pg_white_corner_mask"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4) resizingMode:UIImageResizingModeStretch];
    [self.contentView addSubview:maskImageView];
}

- (void)setCellWithChannelCategory:(PGChannelCategory *)category
{
    [self.categoryImageView setWithImageURL:category.image placeholder:nil completion:nil];
}

- (void)setCellWithScenarioCategory:(PGScenarioCategory *)category
{
    [self.categoryImageView setWithImageURL:category.image placeholder:nil completion:nil];
}

- (void)setMoreCategoryCell
{
    self.categoryImageView.image = [UIImage imageNamed:@"pg_channel_categories_more"];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected) {
        self.dimView.hidden = YES;
        self.horizontalLine.hidden = NO;
    } else {
        self.dimView.hidden = NO;
        self.horizontalLine.hidden = YES;
    }
}

- (UIImageView *)categoryImageView {
	if(_categoryImageView == nil) {
		_categoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, self.pg_height-8)];
        _categoryImageView.clipsToBounds = YES;
        _categoryImageView.contentMode = UIViewContentModeScaleAspectFill;
        _categoryImageView.backgroundColor = Theme.colorText;
	}
	return _categoryImageView;
}

- (UIView *)dimView {
	if(_dimView == nil) {
        _dimView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, self.pg_height-8)];
        _dimView.backgroundColor = [UIColor whiteColorWithAlpha:0.5f];
        _dimView.hidden = NO;
	}
	return _dimView;
}

- (UIView *)horizontalLine
{
    if (!_horizontalLine) {
        _horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.pg_height-3, self.pg_width, 3)];
        _horizontalLine.backgroundColor = Theme.colorExtraHighlight;
        _horizontalLine.hidden = YES;
    }
    return _horizontalLine;
}

@end
