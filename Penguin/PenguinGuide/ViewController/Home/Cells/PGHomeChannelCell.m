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
    [self.channelButton addSubview:self.channelLabel];
}

- (UIButton *)channelButton {
    if(_channelButton == nil) {
        _channelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _channelButton.userInteractionEnabled = NO;
        [_channelButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 20, 0)];
    }
    return _channelButton;
}

- (UILabel *)channelLabel {
    if(_channelLabel == nil) {
        _channelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height-28, self.width, 16)];
        _channelLabel.font = Theme.fontExtraSmallBold;
        _channelLabel.textColor = Theme.colorText;
        _channelLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _channelLabel;
}

@end
