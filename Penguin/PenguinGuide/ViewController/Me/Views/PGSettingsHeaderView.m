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
    
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(45, 10, self.pg_width-90, 1/[UIScreen mainScreen].scale)];
    horizontalLine.backgroundColor = [UIColor colorWithHexString:@"E1E1E1"];
    [self addSubview:horizontalLine];
}

- (void)setHeaderViewWithTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 42, self.pg_width-60, 18)];
        _titleLabel.font = Theme.fontLargeBold;
        _titleLabel.textColor = Theme.colorText;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
