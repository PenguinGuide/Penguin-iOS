//
//  PGHomeCategoryCell.m
//  Penguin
//
//  Created by Jing Dai on 8/24/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGHomeChannelCell.h"

@implementation PGHomeChannelCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    
    return self;
}

- (void)initialize
{
    [self.contentView addSubview:self.channelButton];
    [self.contentView addSubview:self.channelLabel];
}

- (UIButton *)channelButton {
    if(_channelButton == nil) {
        _channelButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, 30, 30)];
        _channelButton.userInteractionEnabled = NO;
    }
    return _channelButton;
}

- (UILabel *)channelLabel {
    if(_channelLabel == nil) {
        _channelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.pg_height-26, self.pg_width, 16)];
        _channelLabel.font = Theme.fontExtraSmallBold;
        _channelLabel.textColor = Theme.colorText;
        _channelLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _channelLabel;
}

@end
