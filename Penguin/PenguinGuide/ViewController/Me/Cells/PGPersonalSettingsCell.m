//
//  PGSettingsCell.m
//  Penguin
//
//  Created by Jing Dai on 26/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGPersonalSettingsCell.h"

@interface PGPersonalSettingsCell ()

@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation PGPersonalSettingsCell

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
}

- (void)setCellWithDesc:(NSString *)desc content:(NSString *)content
{
    self.descLabel.text = desc;
    self.contentLabel.text = content;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 0, 90, self.pg_height)];
        _descLabel.font = Theme.fontMediumBold;
        _descLabel.textColor = Theme.colorText;
    }
    return _descLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.descLabel.pg_right+10, 0, self.pg_width-48-self.descLabel.pg_right-10, self.pg_height)];
        _contentLabel.font = Theme.fontMediumBold;
        _contentLabel.textColor = Theme.colorLightText;
        _contentLabel.textAlignment = NSTextAlignmentRight;
    }
    return _contentLabel;
}

@end
