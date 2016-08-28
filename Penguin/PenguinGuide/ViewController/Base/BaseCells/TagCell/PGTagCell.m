//
//  PGTagCell.m
//  Penguin
//
//  Created by Jing Dai on 8/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGTagCell.h"

@interface PGTagCell ()

@property (nonatomic, strong) UILabel *nameLabel;

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
    [self.contentView addSubview:self.nameLabel];
}

- (void)setCellWithTagName:(NSString *)tagName
{
    CGSize size = [tagName sizeWithAttributes:@{NSFontAttributeName:Theme.fontMediumBold}];
    
    self.nameLabel.text = tagName;
    self.nameLabel.width = size.width+24;
}

+ (CGSize)cellSize:(NSString *)tagName
{
    CGSize size = [tagName sizeWithAttributes:@{NSFontAttributeName:Theme.fontMediumBold}];
    
    return CGSizeMake(size.width+24, 24.f);
}

- (UILabel *)nameLabel {
	if(_nameLabel == nil) {
		_nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _nameLabel.clipsToBounds = YES;
        _nameLabel.layer.cornerRadius = 12.f;
        _nameLabel.backgroundColor = [UIColor colorWithHexString:@"E1E1E1"];
        _nameLabel.font = Theme.fontMediumBold;
        _nameLabel.textColor = Theme.colorExtraHighlight;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _nameLabel;
}

@end
