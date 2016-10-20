//
//  PGTopicHeaderView.m
//  Penguin
//
//  Created by Jing Dai on 14/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGTopicHeaderView.h"

@interface PGTopicHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation PGTopicHeaderView

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
    
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(13, 15, 3, 20)];
    verticalLine.backgroundColor = Theme.colorExtraHighlight;
    
    [self addSubview:verticalLine];
    [self addSubview:self.titleLabel];
}

- (void)setHeaderViewWithTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (UILabel *)titleLabel {
    if(_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 15, UISCREEN_WIDTH-25, 20)];
        _titleLabel.font = Theme.fontMediumBold;
        _titleLabel.textColor = Theme.colorText;
    }
    return _titleLabel;
}

@end
