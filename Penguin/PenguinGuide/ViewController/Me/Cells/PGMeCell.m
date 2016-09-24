//
//  PGMeCell.m
//  Penguin
//
//  Created by Jing Dai on 23/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGMeCell.h"

@interface PGMeCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *numberLabel;

@end

@implementation PGMeCell

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
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.nameLabel];
    
    UIImageView *indicatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width-40-8, (self.height-9)/2, 8, 9)];
    indicatorImageView.image = [UIImage imageNamed:@"pg_me_cell_indicator"];
    [self.contentView addSubview:indicatorImageView];
    
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(27, self.height-1/[UIScreen mainScreen].scale, self.width-27-40, 1/[UIScreen mainScreen].scale)];
    horizontalLine.backgroundColor = [UIColor colorWithHexString:@"E1E1E1"];
    [self.contentView addSubview:horizontalLine];
    
    [self.contentView addSubview:self.numberLabel];
}

- (void)setCellWithIcon:(NSString *)icon name:(NSString *)name count:(NSString *)count highlight:(BOOL)highlight
{
    self.iconImageView.image = [UIImage imageNamed:icon];
    self.nameLabel.text = name;
    self.numberLabel.text = count;
}

+ (CGSize)cellSize
{
    return CGSizeMake(UISCREEN_WIDTH, 70);
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, (self.height-30)/2, 29, 30)];
    }
    return _iconImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImageView.right+20, (self.height-16)/2, 100, 16)];
        _nameLabel.font = Theme.fontMediumBold;
        _nameLabel.textColor = Theme.colorText;
    }
    return _nameLabel;
}

- (UILabel *)numberLabel
{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width-68-30, (self.height-30)/2, 30, 30)];
        _numberLabel.font = Theme.fontMediumBold;
        _numberLabel.textColor = Theme.colorText;
    }
    return _numberLabel;
}

@end
