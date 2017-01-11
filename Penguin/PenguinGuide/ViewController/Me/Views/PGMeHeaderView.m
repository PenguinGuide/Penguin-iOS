//
//  PGMeHeaderView.m
//  Penguin
//
//  Created by Jing Dai on 23/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGMeHeaderView.h"
#import "UIButton+WebCache.h"

@interface PGMeHeaderView ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation PGMeHeaderView

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
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.settingButton];
    [self addSubview:self.avatarButton];
    [self addSubview:self.nameLabel];
    [self addSubview:self.descLabel];
    
//    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(self.pg_width/2-1/[UIScreen mainScreen].scale, self.nameLabel.pg_bottom+11, 1/[UIScreen mainScreen].scale, 20)];
//    horizontalLine.backgroundColor = Theme.colorText;
//    [self addSubview:horizontalLine];
}

- (void)setViewWithMe:(PGMe *)me
{
    if (me) {
        [self.avatarButton sd_setImageWithURL:[NSURL URLWithString:me.avatar]
                                     forState:UIControlStateNormal
                             placeholderImage:[UIImage imageNamed:@"pg_me_avatar_placeholder"]];
        if (me.nickname) {
            self.nameLabel.text = me.nickname;
        }
        
        NSString *desc = @"";
        if ([me.sex isEqualToString:@"男"]) {
            desc = [desc stringByAppendingString:@"男"];
        } else {
            desc = [desc stringByAppendingString:@"女"];
        }
        if (me.location) {
            desc = [desc stringByAppendingString:[NSString stringWithFormat:@"  |  %@", me.location]];
        }
        self.descLabel.text = desc;
    }
}

+ (CGSize)headerViewSize
{
    return CGSizeMake(UISCREEN_WIDTH, 55+84+10+22+10+22+10+30);
}

- (UIButton *)settingButton
{
    if (!_settingButton) {
        _settingButton = [[UIButton alloc] initWithFrame:CGRectMake(self.pg_width-20-50, 30, 50, 50)];
        _settingButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _settingButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        [_settingButton setImage:[UIImage imageNamed:@"pg_me_setting"] forState:UIControlStateNormal];
    }
    return _settingButton;
}

- (UIButton *)avatarButton
{
    if (!_avatarButton) {
        _avatarButton = [[UIButton alloc] initWithFrame:CGRectMake(self.pg_width/2-42, 55, 84, 84)];
        _avatarButton.clipsToBounds = YES;
        _avatarButton.layer.cornerRadius = 42.f;
        _avatarButton.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _avatarButton;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.avatarButton.pg_bottom+20, self.pg_width, 22)];
        _nameLabel.font = [UIFont systemFontOfSize:20.f];
        _nameLabel.textColor = Theme.colorText;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.nameLabel.pg_bottom+20, self.pg_width, 22)];
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.font = Theme.fontSmallBold;
        _descLabel.textColor = Theme.colorLightText;
    }
    return _descLabel;
}

@end
