//
//  PGPersonalSettingsAvatarCell.m
//  Penguin
//
//  Created by Kobe Dai on 11/01/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import "PGPersonalSettingsAvatarCell.h"
#import "UIButton+WebCache.h"

@interface PGPersonalSettingsAvatarCell ()

@property (nonatomic, strong) UIButton *avatarButton;
@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation PGPersonalSettingsAvatarCell

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
    [self.contentView addSubview:self.avatarButton];
    [self.contentView addSubview:self.descLabel];
}

- (void)setCellWithAvatar:(NSString *)avatar
{
    [self.avatarButton sd_setImageWithURL:[NSURL URLWithString:avatar]
                                 forState:UIControlStateNormal
                         placeholderImage:nil];
}

- (UIButton *)avatarButton
{
    if (!_avatarButton) {
        _avatarButton = [[UIButton alloc] initWithFrame:CGRectMake((self.pg_width-80)/2, 22, 80, 80)];
        _avatarButton.clipsToBounds = YES;
        _avatarButton.layer.cornerRadius = 40.f;
        _avatarButton.userInteractionEnabled = NO;
        
        UIImageView *cameraCoverView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 25, 30, 30)];
        cameraCoverView.userInteractionEnabled = NO;
        cameraCoverView.image = [UIImage imageNamed:@"pg_avatar_camera"];
        
        [_avatarButton addSubview:cameraCoverView];
    }
    return _avatarButton;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.avatarButton.pg_bottom+20, self.pg_width, 16)];
        _descLabel.font = Theme.fontMediumBold;
        _descLabel.textColor = Theme.colorLightText;
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.text = @"修 改 头 像";
    }
    return _descLabel;
}

@end
