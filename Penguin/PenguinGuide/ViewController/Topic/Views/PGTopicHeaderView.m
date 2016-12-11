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
    
    [self addSubview:self.titleLabel];
}

- (void)setHeaderViewWithTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (UILabel *)titleLabel {
    if(_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 15, UISCREEN_WIDTH-25, 20)];
        _titleLabel.font = Theme.fontLargeBold;
        _titleLabel.textColor = Theme.colorText;
    }
    return _titleLabel;
}

@end
