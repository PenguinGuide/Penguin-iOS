//
//  PGMessageCell.m
//  Penguin
//
//  Created by Jing Dai on 27/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGMessageCell.h"

@interface PGMessageCell ()

@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation PGMessageCell

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
    self.backgroundColor = [UIColor colorWithHexString:@"FBFBFB"];
    
    [self.contentView addSubview:self.descLabel];
    [self.contentView addSubview:self.countLabel];
    
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.pg_height-1/[UIScreen mainScreen].scale, self.pg_width, 1/[UIScreen mainScreen].scale)];
    horizontalLine.backgroundColor = [UIColor colorWithHexString:@"F1F1F1"];
    [self.contentView addSubview:horizontalLine];
}

- (void)setCellWithDesc:(NSString *)desc count:(NSString *)count
{
    self.descLabel.text = desc;
    self.countLabel.text = count;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 200, 50)];
        _descLabel.font = Theme.fontMedium;
        _descLabel.textColor = Theme.colorText;
    }
    return _descLabel;
}

- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(UISCREEN_WIDTH-50-100, 0, 100, 50)];
        _countLabel.font = Theme.fontMedium;
        _countLabel.textColor = Theme.colorText;
        _countLabel.textAlignment = NSTextAlignmentRight;
    }
    return _countLabel;
}

@end
