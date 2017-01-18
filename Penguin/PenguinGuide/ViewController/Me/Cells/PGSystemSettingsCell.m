//
//  PGSystemSettingsCell.m
//  Penguin
//
//  Created by Kobe Dai on 10/01/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import "PGSystemSettingsCell.h"

@interface PGSystemSettingsCell ()

@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation PGSystemSettingsCell

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
}

- (void)setCellWithDesc:(NSString *)desc
{
    self.descLabel.text = desc;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, self.pg_width-60, self.pg_height)];
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.font = Theme.fontExtraLargeBold;
        _descLabel.textColor = Theme.colorText;
    }
    return _descLabel;
}

@end
