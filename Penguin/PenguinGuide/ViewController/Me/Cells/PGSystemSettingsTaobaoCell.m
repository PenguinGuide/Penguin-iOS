//
//  PGSystemSettingsTaobaoCell.m
//  Penguin
//
//  Created by Kobe Dai on 10/01/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import "PGSystemSettingsTaobaoCell.h"

@interface PGSystemSettingsTaobaoCell ()

@property (nonatomic, strong) UIImageView *taobaoIconView;
@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation PGSystemSettingsTaobaoCell

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
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(50, 0, self.pg_width-100, 1/[UIScreen mainScreen].scale)];
    horizontalLine.backgroundColor = [UIColor colorWithHexString:@"E1E1E1"];
    
    [self.contentView addSubview:horizontalLine];
    [self.contentView addSubview:self.taobaoIconView];
    [self.contentView addSubview:self.descLabel];
}

- (void)setCellWithAuthorized:(BOOL)authorized
{
    UIImage *iconImage;
    NSString *str;
    
    if (authorized) {
        iconImage = [UIImage imageNamed:@"pg_setting_taobao_highlight"];
        str = @"淘 宝 已 授 权";
    } else {
        iconImage = [UIImage imageNamed:@"pg_setting_taobao"];
        str = @"淘 宝 未 授 权";
    }
    
    NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:str];
    [attrS addAttribute:NSForegroundColorAttributeName value:Theme.colorText range:NSMakeRange(0, str.length)];
    [attrS addAttribute:NSFontAttributeName value:Theme.fontMediumBold range:NSMakeRange(0, str.length)];
    
    self.taobaoIconView.image = iconImage;
    self.descLabel.attributedText = attrS;
    
    self.descLabel.frame = CGRectMake(self.pg_width/2-attrS.size.width/2+(22+10)/2, 0, attrS.size.width, self.pg_height);
    self.taobaoIconView.frame = CGRectMake(self.descLabel.pg_left-10-22, self.pg_height/2-11, 22, 22);
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 0, self.pg_height)];
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.font = Theme.fontMediumBold;
        _descLabel.textColor = Theme.colorText;
    }
    return _descLabel;
}

- (UIImageView *)taobaoIconView
{
    if (!_taobaoIconView) {
        _taobaoIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    }
    return _taobaoIconView;
}

@end
