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
@property (nonatomic, strong) UIView *dotView;

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
    [self.contentView addSubview:self.dotView];
    
    UIImageView *indicatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.pg_width-40-8, (self.pg_height-9)/2, 8, 9)];
    indicatorImageView.image = [UIImage imageNamed:@"pg_me_cell_indicator"];
    [self.contentView addSubview:indicatorImageView];
    
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(27, self.pg_height-1/[UIScreen mainScreen].scale, self.pg_width-27-40, 1/[UIScreen mainScreen].scale)];
    horizontalLine.backgroundColor = [UIColor colorWithHexString:@"E1E1E1"];
    [self.contentView addSubview:horizontalLine];
    
    [self.contentView addSubview:self.numberLabel];
}

- (void)setCellWithIcon:(NSString *)icon name:(NSString *)name count:(NSString *)count
{
    self.iconImageView.image = [UIImage imageNamed:icon];
    self.nameLabel.text = name;
    self.numberLabel.text = count;
    self.dotView.hidden = YES;
}

- (void)setCellWithIcon:(NSString *)icon name:(NSString *)name highlight:(BOOL)highlight
{
    self.iconImageView.image = [UIImage imageNamed:icon];
    self.nameLabel.text = name;
    self.numberLabel.text = nil;
    if (highlight) {
        self.dotView.hidden = NO;
    } else {
        self.dotView.hidden = YES;
    }
}

+ (CGSize)cellSize
{
    return CGSizeMake(UISCREEN_WIDTH, 70);
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, (self.pg_height-30)/2, 29, 30)];
    }
    return _iconImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImageView.pg_right+20, (self.pg_height-16)/2, 70, 16)];
        _nameLabel.font = Theme.fontMediumBold;
        _nameLabel.textColor = Theme.colorText;
    }
    return _nameLabel;
}

- (UILabel *)numberLabel
{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.pg_width-68-30, (self.pg_height-30)/2, 30, 30)];
        _numberLabel.font = Theme.fontMediumBold;
        _numberLabel.textColor = Theme.colorText;
    }
    return _numberLabel;
}

- (UIView *)dotView
{
    if (!_dotView) {
        _dotView = [[UIView alloc] initWithFrame:CGRectMake(self.nameLabel.frame.origin.x+self.nameLabel.frame.size.width, self.nameLabel.frame.origin.y-2, 8, 8)];
        _dotView.clipsToBounds = YES;
        _dotView.layer.cornerRadius = 4.f;
        _dotView.backgroundColor = [UIColor colorWithRed:239.f/256.f green:103.f/256.f blue:51.f/256.f alpha:1.f];
    }
    return _dotView;
}

@end
