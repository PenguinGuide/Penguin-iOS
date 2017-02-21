//
//  PGTagCell.m
//  Penguin
//
//  Created by Jing Dai on 8/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGTagCell.h"

@interface PGTagCell ()

@property (nonatomic, strong) UIButton *nameButton;

@end

@implementation PGTagCell

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
    [self.contentView addSubview:self.nameButton];
}

- (void)setCellWithTagName:(NSString *)tagName
{
    CGSize size = [tagName sizeWithAttributes:@{NSFontAttributeName:Theme.fontSmall}];
    
    self.nameButton.backgroundColor = Theme.colorText;
    self.nameButton.layer.cornerRadius = 10.f;
    self.nameButton.pg_width = size.width+24;
    [self.nameButton.titleLabel setFont:Theme.fontMediumBold];
    [self.nameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nameButton setTitle:tagName forState:UIControlStateNormal];
}

+ (CGSize)cellSize:(NSString *)tagName
{
    CGSize size = [tagName sizeWithAttributes:@{NSFontAttributeName:Theme.fontSmall}];
    
    return CGSizeMake(size.width+30, 20.f);
}

- (void)setCellWithKeyword:(NSString *)keyword
{
    CGSize size = [keyword sizeWithAttributes:@{NSFontAttributeName:Theme.fontMediumBold}];
    
    self.nameButton.backgroundColor = [UIColor colorWithHexString:@"F1F1F1"];
    self.nameButton.layer.cornerRadius = 12.f;
    self.nameButton.pg_width = size.width+24;
    [self.nameButton.titleLabel setFont:Theme.fontMediumBold];
    [self.nameButton setTitleColor:Theme.colorExtraHighlight forState:UIControlStateNormal];
    [self.nameButton setTitle:keyword forState:UIControlStateNormal];
}

+ (CGSize)keywordCellSize:(NSString *)keyword
{
    CGSize size = [keyword sizeWithAttributes:@{NSFontAttributeName:Theme.fontMediumBold}];
    
    return CGSizeMake(size.width+24, 30.f);
}

- (UIButton *)nameButton {
	if(_nameButton == nil) {
		_nameButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, self.pg_height)];
        _nameButton.clipsToBounds = YES;
        _nameButton.layer.cornerRadius = 12.f;
        _nameButton.backgroundColor = [UIColor clearColor];
        _nameButton.userInteractionEnabled = NO;
        [_nameButton.titleLabel setFont:Theme.fontMediumBold];
        [_nameButton setTitleColor:Theme.colorExtraHighlight forState:UIControlStateNormal];
	}
	return _nameButton;
}

@end
