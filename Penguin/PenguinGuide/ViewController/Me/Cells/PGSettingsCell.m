//
//  PGSettingsCell.m
//  Penguin
//
//  Created by Jing Dai on 26/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGSettingsCell.h"

@interface PGSettingsCell ()

@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *contentImageView;

@end

@implementation PGSettingsCell

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
    [self.contentView addSubview:self.descLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.contentImageView];
    
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(27, self.pg_height-1/[UIScreen mainScreen].scale, self.pg_width-27-39, 1/[UIScreen mainScreen].scale)];
    horizontalLine.backgroundColor = [UIColor colorWithHexString:@"E1E1E1"];
    [self.contentView addSubview:horizontalLine];
}

- (void)setCellWithDesc:(NSString *)desc content:(NSString *)content isImage:(BOOL)isImage
{
    if (isImage) {
        self.contentImageView.hidden = NO;
        self.descLabel.text = desc;
        [self.contentImageView setWithImageURL:content placeholder:nil completion:nil];
    } else {
        self.contentImageView.hidden = YES;
        self.descLabel.text = desc;
        self.contentLabel.text = content;
    }
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 0, 90, self.pg_height)];
        _descLabel.font = Theme.fontMediumBold;
        _descLabel.textColor = Theme.colorText;
    }
    return _descLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.descLabel.pg_right+10, 0, self.pg_width-44-self.descLabel.pg_right-10, self.pg_height)];
        _contentLabel.font = Theme.fontMediumBold;
        _contentLabel.textColor = Theme.colorLightText;
        _contentLabel.textAlignment = NSTextAlignmentRight;
    }
    return _contentLabel;
}

- (UIImageView *)contentImageView
{
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.pg_width-48-30, self.pg_height/2-15, 30, 30)];
        _contentImageView.clipsToBounds = YES;
        _contentImageView.layer.cornerRadius = 15.f;
    }
    return _contentImageView;
}

@end
