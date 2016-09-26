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
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 0, 100, self.height)];
        _descLabel.font = Theme.fontMediumBold;
        _descLabel.textColor = Theme.colorText;
    }
    return _descLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width-44-100, 0, 100, self.height)];
        _contentLabel.font = Theme.fontMediumBold;
        _contentLabel.textColor = Theme.colorLightText;
    }
    return _contentLabel;
}

- (UIImageView *)contentImageView
{
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width-48-30, self.height/2-15, 30, 30)];
        _contentImageView.clipsToBounds = YES;
        _contentImageView.layer.cornerRadius = 15.f;
    }
    return _contentImageView;
}

@end
