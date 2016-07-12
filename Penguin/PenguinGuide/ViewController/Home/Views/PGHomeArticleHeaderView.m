//
//  PGHomeArticleHeaderView.m
//  Penguin
//
//  Created by Jing Dai on 7/12/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGHomeArticleHeaderView.h"

@interface PGHomeArticleHeaderView ()

@property (nonatomic, strong, readwrite) UILabel *dateLabel;

@end

@implementation PGHomeArticleHeaderView

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
    [self addSubview:self.dateLabel];
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _dateLabel.font = Theme.fontMedium;
        _dateLabel.textColor = [UIColor blackColor];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _dateLabel;
}

@end
