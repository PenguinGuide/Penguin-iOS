//
//  PGMessageContentCell.m
//  Penguin
//
//  Created by Jing Dai on 27/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGMessageContentCell.h"

@interface PGMessageContentCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIImageView *dotImageView;

@end

@implementation PGMessageContentCell

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
    [self.contentView addSubview:self.messageLabel];
//    [self.contentView addSubview:self.dotImageView];
    
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(47, self.pg_height-1/[UIScreen mainScreen].scale, self.pg_width, 1/[UIScreen mainScreen].scale)];
    horizontalLine.backgroundColor = [UIColor colorWithHexString:@"F1F1F1"];
    [self.contentView addSubview:horizontalLine];
}

- (void)setCellWithMessage:(PGMessage *)message type:(NSString *)type
{
    if (message) {
        if ([type isEqualToString:@"system"]) {
            self.iconImageView.image = [UIImage imageNamed:@"pg_me_avatar_placeholder"];
        } else {
            [self.iconImageView setWithImageURL:message.content.avatar placeholder:nil completion:nil];
        }
        if ([type isEqualToString:@"system"]) {
            [self.messageLabel setText:message.content.content];
        } else if ([type isEqualToString:@"reply"]) {
            [self.messageLabel setText:[NSString stringWithFormat:@"%@回复了你：%@", message.content.nickname, message.content.content]];
        } else if ([type isEqualToString:@"likes"]) {
            [self.messageLabel setText:[NSString stringWithFormat:@"%@赞了你：%@", message.content.nickname, message.content.content]];
        }
    }
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 14, 22, 22)];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.clipsToBounds = YES;
        
        UIImageView *maskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        maskImageView.image = [[UIImage imageNamed:@"pg_avatar_white_corner_mask"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
        [_iconImageView addSubview:maskImageView];
    }
    return _iconImageView;
}

- (UILabel *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, UISCREEN_WIDTH-50-30, 50)];
        _messageLabel.font = Theme.fontLargeBold;
        _messageLabel.textColor = Theme.colorText;
    }
    return _messageLabel;
}

- (UIImageView *)dotImageView
{
    if (!_dotImageView) {
        _dotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(UISCREEN_WIDTH-15, 10, 6, 6)];
        _dotImageView.image = [UIImage imageNamed:@"pg_message_red_dot"];
    }
    return _dotImageView;
}

@end
