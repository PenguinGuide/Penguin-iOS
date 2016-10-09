//
//  PGSettingsHeaderView.m
//  Penguin
//
//  Created by Jing Dai on 07/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGSettingsHeaderView.h"

@interface PGSettingsHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation PGSettingsHeaderView

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
    [self addSubview:self.titleLabel];
    
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(27, self.pg_height-2, self.pg_width-27-39, 2)];
    horizontalLine.backgroundColor = Theme.colorText;
    [self addSubview:horizontalLine];
}

- (void)setHeaderViewWithTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, self.pg_width-60, self.pg_height)];
        _titleLabel.font = Theme.fontLargeBold;
        _titleLabel.textColor = Theme.colorText;
    }
    return _titleLabel;
}

@end
