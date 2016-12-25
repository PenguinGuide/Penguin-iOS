//
//  PGCollectionCell.m
//  Penguin
//
//  Created by Jing Dai on 28/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGCollectionCell.h"

@interface PGCollectionCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation PGCollectionCell

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
    self.backgroundColor = [UIColor colorWithHexString:@"FBFBFB"];
    
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.descLabel];
    [self.contentView addSubview:self.countLabel];
    
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.pg_height-1/[UIScreen mainScreen].scale, self.pg_width, 1/[UIScreen mainScreen].scale)];
    horizontalLine.backgroundColor = [UIColor colorWithHexString:@"F1F1F1"];
    [self.contentView addSubview:horizontalLine];
}

- (void)setCellWithIcon:(NSString *)icon desc:(NSString *)desc count:(NSString *)count
{
    [self.iconImageView setWithImageURL:icon placeholder:nil completion:nil];
    [self.descLabel setText:desc];
    [self.countLabel setText:count];
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 11, 28, 28)];
        _iconImageView.clipsToBounds = YES;
        _iconImageView.layer.cornerRadius = 14.f;
    }
    return _iconImageView;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImageView.pg_right+25, 0, 100, 50)];
        _descLabel.font = Theme.fontMedium;
        _descLabel.textColor = Theme.colorText;
    }
    return _descLabel;
}

- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(UISCREEN_WIDTH-50-100, 0, 100, 50)];
        _countLabel.font = Theme.fontMedium;
        _countLabel.textColor = Theme.colorText;
        _countLabel.textAlignment = NSTextAlignmentRight;
    }
    return _countLabel;
}

@end
